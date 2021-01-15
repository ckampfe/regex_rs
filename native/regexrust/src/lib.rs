use rustler::resource::ResourceArc;
use rustler::{resource, Encoder, Env, Error, Term};
use std::borrow::Cow;
use std::collections::HashMap;

type CompiledRegex = ResourceArc<RegexResource>;

struct RegexResource {
    regex: regex::Regex,
}

mod atoms {
    rustler::atoms! {
        ok
    }
}

fn on_load(env: Env, _info: Term) -> bool {
    resource!(RegexResource, env);
    true
}

rustler::init!(
    "Elixir.RegexRs",
    [
        compile,
        find_iter,
        is_match,
        named_captures,
        replace,
        replace_all,
        run,
        source,
    ],
    load = on_load
);

#[rustler::nif]
fn compile(s: &str) -> Result<(rustler::Atom, CompiledRegex), Error> {
    let regex = regex::Regex::new(s);
    match regex {
        Ok(regex) => {
            let resource = ResourceArc::new(RegexResource { regex });
            Ok((atoms::ok(), resource))
        }
        Err(e) => Err(rustler::Error::Term(Box::new(e.to_string()))),
    }
}

#[rustler::nif]
fn run(re: CompiledRegex, s: &str) -> Vec<&str> {
    if let Some(captures) = re.regex.captures(s) {
        captures
            .iter()
            .flat_map(|m| m.map(|mm| mm.as_str()))
            .collect()
    } else {
        vec![]
    }
}

#[rustler::nif]
fn find_iter(re: CompiledRegex, s: &str) -> Vec<&str> {
    re.regex.find_iter(s).map(|m| m.as_str()).collect()
}

#[rustler::nif]
fn is_match(re: CompiledRegex, s: &str) -> bool {
    re.regex.is_match(s)
}

#[rustler::nif]
fn named_captures(re: CompiledRegex, s: &str) -> EncodableHashMap<String, String> {
    let names = re.regex.capture_names();
    let mut m = HashMap::with_capacity(names.len());

    if let Some(captures) = re.regex.captures(s) {
        for name in names {
            if let Some(name) = name {
                m.insert(name.to_owned(), captures[name].to_owned());
            }
        }
    }

    m.into()
}

#[rustler::nif]
fn source(re: CompiledRegex) -> String {
    re.regex.as_str().to_owned()
}

#[rustler::nif]
fn replace<'a>(re: CompiledRegex, s: &'a str, replacement: &str) -> EncodableCow<'a> {
    re.regex.replace(s, replacement).into()
}

#[rustler::nif]
fn replace_all<'a>(re: CompiledRegex, s: &'a str, replacement: &str) -> EncodableCow<'a> {
    re.regex.replace_all(s, replacement).into()
}

struct EncodableHashMap<K, V>(HashMap<K, V>);

impl<K, V> From<HashMap<K, V>> for EncodableHashMap<K, V> {
    fn from(hm: HashMap<K, V>) -> Self {
        EncodableHashMap(hm)
    }
}

impl<K, V> Encoder for EncodableHashMap<K, V>
where
    K: Encoder,
    V: Encoder,
{
    fn encode<'b>(&self, env: Env<'b>) -> Term<'b> {
        // TODO: this an alternate implementation that works.
        // TODO: it may be worth benchmarking
        //
        // let keys: Vec<Term<'b>> = self.0.keys().map(|k| k.encode(env)).collect();
        // let values: Vec<Term<'b>> = self.0.values().map(|v| v.encode(env)).collect();
        // let keys = keys.as_slice();
        // let values = values.as_slice();
        // rustler::Term::map_from_arrays(env, keys, values).unwrap()

        let mut m = Term::map_new(env);

        for (k, v) in self.0.iter() {
            m = m.map_put(k.encode(env), v.encode(env)).unwrap()
        }

        m
    }
}

struct EncodableCow<'a>(Cow<'a, str>);

impl<'a> From<Cow<'a, str>> for EncodableCow<'a> {
    fn from(cow: Cow<'a, str>) -> Self {
        EncodableCow(cow)
    }
}

impl<'a> Encoder for EncodableCow<'a> {
    fn encode<'b>(&self, env: Env<'b>) -> Term<'b> {
        self.0.encode(env)
    }
}
