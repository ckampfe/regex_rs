use rustler::resource::ResourceArc;
use rustler::{Encoder, Env, Error, Term};
use std::borrow::Cow;

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
    rustler::resource!(RegexResource, env);
    true
}

rustler::init!(
    "Elixir.RegexRs",
    [
        as_str,
        capture_names,
        captures,
        captures_named,
        captures_iter,
        captures_iter_named,
        captures_len,
        find,
        find_iter,
        is_match,
        new,
        replace,
        replace_all,
    ],
    load = on_load
);

#[rustler::nif(name = "new_internal")]
fn new(s: &str) -> Result<(rustler::Atom, CompiledRegex), Error> {
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
fn captures(re: CompiledRegex, s: &str) -> Option<Vec<&str>> {
    re.regex.captures(s).map(|captures| {
        captures
            .iter()
            .flat_map(|m| m.map(|mm| mm.as_str()))
            .collect()
    })
}

#[rustler::nif]
fn capture_names(re: CompiledRegex) -> Vec<String> {
    re.regex
        .capture_names()
        .map(|c| match c {
            Some(named_capture) => named_capture.to_owned(),
            None => "unnamed_capture".to_string(),
        })
        .collect()
}

#[rustler::nif]
fn captures_named(re: CompiledRegex, s: &str) -> Option<EncodablePairs<String, String>> {
    let names = re.regex.capture_names();

    re.regex.captures(s).map(|c| {
        names
            .flatten()
            .map(|name| (name.to_owned(), c[name].to_owned()))
            .collect::<Vec<(String, String)>>()
            .into()
    })
}

#[rustler::nif]
fn captures_iter(re: CompiledRegex, s: &str) -> Vec<Vec<&str>> {
    re.regex
        .captures_iter(s)
        .map(|capture| {
            capture
                .iter()
                .flat_map(|c| c.map(|cc| cc.as_str()))
                .collect()
        })
        .collect()
}

#[rustler::nif]
fn captures_iter_named(re: CompiledRegex, s: &str) -> Vec<EncodablePairs<String, String>> {
    let names = re.regex.capture_names();

    re.regex
        .captures_iter(s)
        .map(|capture| {
            names
                .clone()
                .flatten()
                .map(|name| (name.to_owned(), capture[name].to_owned()))
                .collect::<Vec<(String, String)>>()
                .into()
        })
        .collect()
}

#[rustler::nif]
fn captures_len(re: CompiledRegex) -> usize {
    re.regex.captures_len()
}

#[rustler::nif]
fn find(re: CompiledRegex, s: &str) -> Option<&str> {
    re.regex.find(s).map(|m| m.as_str())
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
fn as_str(re: CompiledRegex) -> String {
    re.regex.as_str().to_owned()
}

#[rustler::nif]
fn replace<'a>(re: CompiledRegex, s: &'a str, replacement: &str) -> EncodableCow<'a, str> {
    re.regex.replace(s, replacement).into()
}

#[rustler::nif]
fn replace_all<'a>(re: CompiledRegex, s: &'a str, replacement: &str) -> EncodableCow<'a, str> {
    re.regex.replace_all(s, replacement).into()
}

struct EncodablePairs<K, V>(Vec<(K, V)>);

impl<T: Into<Vec<(K, V)>>, K, V> From<T> for EncodablePairs<K, V> {
    fn from(pairs: T) -> Self {
        EncodablePairs(pairs.into())
    }
}

impl<K, V> Encoder for EncodablePairs<K, V>
where
    K: Encoder,
    V: Encoder,
{
    fn encode<'b>(&self, env: Env<'b>) -> Term<'b> {
        let mut m = Term::map_new(env);

        for (k, v) in self.0.iter() {
            m = m.map_put(k.encode(env), v.encode(env)).unwrap()
        }

        m
    }
}

struct EncodableCow<'a, T: ?Sized + ToOwned>(Cow<'a, T>);

impl<'a, T: ?Sized + ToOwned> From<Cow<'a, T>> for EncodableCow<'a, T> {
    fn from(cow: Cow<'a, T>) -> Self {
        EncodableCow(cow)
    }
}

impl<'a, T: ?Sized + ToOwned + Encoder> Encoder for EncodableCow<'a, T> {
    fn encode<'b>(&self, env: Env<'b>) -> Term<'b> {
        self.0.encode(env)
    }
}
