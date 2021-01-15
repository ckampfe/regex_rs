regex_str = "[a-z]+\\s+\\d+"
small_hit_str = "abc 123 def 456"
big_hit_str = Enum.reduce(1..1000, "", fn _val, acc ->
                "#{acc}#{small_hit_str}"
              end)
small_miss_str = "abc abc abc abc"
big_miss_str = Enum.reduce(1..1000, "", fn _val, acc ->
  "#{acc}#{small_miss_str}"
end)

elixir_regex = Regex.compile!(regex_str)
{:ok, rust_regex} = RegexRs.compile(regex_str)

{:ok, rust_named_capture_regex} = RegexRs.compile("(?P<foo>\\d+)")
elixir_named_capture_regex = Regex.compile!("(?<foo>\\d+)")

{:ok, rust_run_regex} = RegexRs.compile("[a-z]+\\s+\(\\d+\)")
elixir_run_regex = Regex.compile!("[a-z]+\\s+\(\\d+\)")

{:ok, rust_replacement_regex} = RegexRs.compile("(?P<letters>[a-z]+)\\s+(?P<digits>\\d+)")
elixir_replacement_regex = Regex.compile!("(?P<letters>[a-z]+)\\s+(?P<digits>\\d+)")

Benchee.run(
  %{
    # "elixir scan" => fn i ->
    #   Regex.scan(elixir_regex, i)
    # end,
    # "rust scan" => fn i ->
    #   RegexRs.find_iter(rust_regex, i)
    # end,
    # "rust match" => fn i ->
    #   RegexRs.is_match(rust_regex, i)
    # end,
    # "elixir match" => fn i ->
    #   Regex.match?(elixir_regex, i)
    # end,
    # "rust named captures" => fn i ->
    #   RegexRs.named_captures(rust_named_capture_regex, i)
    # end,
    # "elixir named captures" => fn i ->
    #   Regex.named_captures(elixir_named_capture_regex, i)
    # end,
    # "rust run" => fn i ->
    #   RegexRs.run(rust_run_regex, i)
    # end,
    # "elixir run" => fn i ->
    #   Regex.run(elixir_run_regex, i)
    # end,
    "rust replace numbered" => fn i ->
      RegexRs.replace(rust_replacement_regex, i, "$2 $1")
    end,
    "rust replace named" => fn i ->
      RegexRs.replace(rust_replacement_regex, i, "$digits $letters")
    end,
    "elixir replace" => fn i ->
      # replace only the first
      Regex.replace(elixir_replacement_regex, i, "\\2 \\1", global: false)
    end,
    "rust replace_all numbered" => fn i ->
      RegexRs.replace_all(rust_replacement_regex, i, "$2 $1")
    end,
    "rust replace_all named" => fn i ->
      RegexRs.replace_all(rust_replacement_regex, i, "$digits $letters")
    end,
    "elixir replace all" => fn i ->
      # replace all
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
