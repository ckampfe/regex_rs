#  - [x] as_str
#  - [ ] capture_locations
#  - [ ] capture_names
#  - [x] captures (+ _named)
#  - [x] captures_iter (+ _named)
#  - [ ] captures_len
#  - [ ] captures_read
#  - [ ] catpures_read_at
#  - [x] find
#  - [ ] find_at
#  - [x] find_iter
#  - [x] is_match
#  - [ ] is_match_at
#  - [ ] new
#  - [x] replace
#  - [x] replace_all
#  - [ ] replacen
#  - [ ] shortest_match
#  - [ ] shortest_match_at
#  - [ ] split
#  - [ ] splitn

small_hit_str = "abc 123 def 456"
big_hit_str = Enum.reduce(1..1000, "", fn _val, acc ->
                "#{acc}#{small_hit_str}"
              end)
small_miss_str = "abc abc abc abc"
big_miss_str = Enum.reduce(1..1000, "", fn _val, acc ->
  "#{acc}#{small_miss_str}"
end)

elixir_run_regex = ~r/[a-z]+\s+(\d+)/
{:ok, rust_run_regex} = RegexRs.new(elixir_run_regex)

elixir_named_capture_regex = ~r/(?P<foo>\d+)/
{:ok, rust_named_capture_regex} = RegexRs.new(elixir_named_capture_regex)

elixir_replacement_regex = ~r/(?P<letters>[a-z]+)\s+(?P<digits>\d+)/
{:ok, rust_replacement_regex} = RegexRs.new(elixir_replacement_regex)


Benchee.run(
  %{
    ## Rust: RegexRs

    "rust is_match/2" => fn i ->
      RegexRs.is_match(rust_run_regex, i)
    end,
    "rust find/2" => fn i ->
      RegexRs.find(rust_run_regex, i)
    end,
    "rust find_iter/2" => fn i ->
      RegexRs.find_iter(rust_run_regex, i)
    end,
    "rust captures/2" => fn i ->
      RegexRs.captures(rust_named_capture_regex, i)
    end,
    "rust captures_named/2" => fn i ->
      RegexRs.captures_named(rust_named_capture_regex, i)
    end,
    "rust captures_iter/2" => fn i ->
      RegexRs.captures_iter(rust_named_capture_regex, i)
    end,
    "rust captures_iter_named/2" => fn i ->
      RegexRs.captures_iter_named(rust_named_capture_regex, i)
    end,
    "rust replace/3 numbered" => fn i ->
      RegexRs.replace(rust_replacement_regex, i, "$2 $1")
    end,
    "rust replace/3 named" => fn i ->
      RegexRs.replace(rust_replacement_regex, i, "$digits $letters")
    end,
    "rust replace_all/3 numbered" => fn i ->
      RegexRs.replace_all(rust_replacement_regex, i, "$2 $1")
    end,
    "rust replace_all/3 named" => fn i ->
      RegexRs.replace_all(rust_replacement_regex, i, "$digits $letters")
    end,

    ## Elixir: Regex

    "elixir named_captures/2" => fn i ->
      Regex.named_captures(elixir_named_capture_regex, i)
    end,
    "elixir run/2" => fn i ->
      Regex.run(elixir_run_regex, i)
    end,
    "elixir match?/2" => fn i ->
      Regex.match?(elixir_run_regex, i)
    end,
    "elixir scan/2" => fn i ->
      Regex.scan(elixir_run_regex, i)
    end,
    "elixir replace/4 first match" => fn i ->
      Regex.replace(elixir_replacement_regex, i, "\\2 \\1", global: false)
    end,
    "elixir replace/4 all" => fn i ->
      Regex.replace(elixir_replacement_regex, i, "\\2 \\1", global: true)
    end
  },
  inputs: %{
    "small hit" => small_hit_str,
    "small miss" => small_miss_str,
    "big hit" => big_hit_str,
    "big miss" => big_miss_str
  }
)
