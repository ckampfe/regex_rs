defmodule RegexRsTest do
  use ExUnit.Case, async: true
  doctest RegexRs

  test "compile/2" do
    assert {:ok, _re} = RegexRs.compile("\\d+")
    assert {:error, _e} = RegexRs.compile("\\U\\P")
    assert {:ok, _} = RegexRs.compile(~r/\d+/)
  end

  test "run/2" do
    {:ok, re} = RegexRs.compile("[a-z]+\\s+\(\\d+\)")
    assert ["abc 123", "123"] = RegexRs.run(re, "abc 123 def 456")
    assert [] = RegexRs.run(re, "abc abc abc abc")
    # elixir regex
    {:ok, ere} = Regex.compile("[a-z]+\\s+\(\\d+\)")
    assert ["abc 123", "123"] = Regex.run(ere, "abc 123 def 456")
  end

  test "source/1" do
    regex_str = "(?P<alpha>[a-z]+)\\s+(?P<digits>\\d+)"
    {:ok, rust_multi_named_capture_regex} = RegexRs.compile(regex_str)
    assert regex_str == RegexRs.source(rust_multi_named_capture_regex)
  end

  test "scan/2" do
    {:ok, re} = RegexRs.compile("\\d+")
    assert ["12345"] = RegexRs.scan(re, "12345")
    assert ["12345", "66666"] = RegexRs.scan(re, "12345 66666")
    assert [] = RegexRs.scan(re, "abcde")
  end

  test "is_match/2" do
    {:ok, re} = RegexRs.compile("\\d+")
    assert RegexRs.is_match(re, "12345")
    refute RegexRs.is_match(re, "abcde")
  end

  test "named_captures/2" do
    {:ok, re} = RegexRs.compile("c(?P<foo>d)")
    %{"foo" => "d"} = RegexRs.named_captures(re, "abcd")
    small_hit_str = "abc 123 def 456"

    # elixir
    elixir_named_capture_regex = Regex.compile!("(?<foo>\\d+).*")
    assert %{"foo" => "123"} = Regex.named_captures(elixir_named_capture_regex, small_hit_str)

    # rust
    {:ok, rust_named_capture_regex} = RegexRs.compile("(?P<foo>\\d+)")
    assert %{"foo" => "123"} = RegexRs.named_captures(rust_named_capture_regex, small_hit_str)

    big_hit_str =
      Enum.reduce(1..1000, "", fn _val, acc ->
        "#{acc}#{small_hit_str}"
      end)

    assert %{"foo" => "123"} = Regex.named_captures(elixir_named_capture_regex, big_hit_str)
    assert %{"foo" => "123"} = RegexRs.named_captures(rust_named_capture_regex, big_hit_str)

    # rust
    {:ok, rust_multi_named_capture_regex} =
      RegexRs.compile("(?P<alpha>[a-z]+)\\s+(?P<digits>\\d+)")

    assert %{"alpha" => "abc", "digits" => "123"} =
             RegexRs.named_captures(rust_multi_named_capture_regex, small_hit_str)

    assert %{"alpha" => "abc", "digits" => "123"} =
             RegexRs.named_captures(rust_multi_named_capture_regex, big_hit_str)

    assert %{} = RegexRs.named_captures(rust_multi_named_capture_regex, "nonmatchingstring")
  end

  test "replace/3" do
    {:ok, re} = RegexRs.compile("(?P<last>[^,\\s]+),\\s+(?P<first>\\S+)")
    assert "Bruce Springsteen" == RegexRs.replace(re, "Springsteen, Bruce", "$first $last")
    assert "Bruce_Springsteen" == RegexRs.replace(re, "Springsteen, Bruce", "${first}_$last")
    assert "Bruce Springsteen" == RegexRs.replace(re, "Springsteen, Bruce", "$2 $1")
    assert "234234902834" == RegexRs.replace(re, "234234902834", "$first $last")
    assert "" == RegexRs.replace(re, "", "$2 $1")
    {:ok, rust_replacement_regex} = RegexRs.compile("(?P<letters>[a-z]+)\\s+(?P<digits>\\d+)")
    assert "123 abc" == RegexRs.replace(rust_replacement_regex, "abc 123", "$2 $1")
    assert "123 abc" == RegexRs.replace(rust_replacement_regex, "abc 123", "$digits $letters")
  end

  test "replace_all/3" do
    {:ok, re} = RegexRs.compile("(?P<last>[^,\\s]+),\\s+(?P<first>\\S+)")

    assert "Bruce Springsteen Bruce Springsteen" ==
             RegexRs.replace_all(re, "Springsteen, Bruce Springsteen, Bruce", "$first $last")

    assert "Bruce_Springsteen Bruce_Springsteen" ==
             RegexRs.replace_all(re, "Springsteen, Bruce Springsteen, Bruce", "${first}_$last")

    assert "Bruce Springsteen Bruce Springsteen" ==
             RegexRs.replace_all(re, "Springsteen, Bruce Springsteen, Bruce", "$2 $1")

    assert "" == RegexRs.replace_all(re, "", "$first $last")
    assert "" == RegexRs.replace_all(re, "", "$2 $1")
    {:ok, rust_replacement_regex} = RegexRs.compile("(?P<letters>[a-z]+)\\s+(?P<digits>\\d+)")

    assert "123 abc 456 def" ==
             RegexRs.replace_all(rust_replacement_regex, "abc 123 def 456", "$2 $1")

    assert "123 abc 456 def" ==
             RegexRs.replace_all(rust_replacement_regex, "abc 123 def 456", "$digits $letters")
  end
end
