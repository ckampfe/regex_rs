# RegexRs

Rust's [regex](https://crates.io/crates/regex) library as an Elixir NIF.

## Installation

```elixir
def deps do
  [
    {:regex_rs, git: "https://github.com/ckampfe/regex_rs.git"}
  ]
end
```

## Todo

- [ ] Two separate modules: one for regular schedulers one for dirty schedulers
- [ ] Better tests
- [ ] More Rust regex API coverage
- [ ] Does it make sense to try to match Elixir API?
- [ ] Hex?
