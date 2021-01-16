defmodule RegexRsTest do
  use ExUnit.Case, async: true
  doctest RegexRs

  test "new/1" do
    assert {:ok, _re} = RegexRs.new("\\d+")
    assert {:error, _e} = RegexRs.new("\\U\\P")
    assert {:ok, _} = RegexRs.new(~r/\d+/)
  end

  test "captures/2" do
    {:ok, re} = RegexRs.new("[a-z]+\\s+\(\\d+\)")
    assert ["abc 123", "123"] == RegexRs.captures(re, "abc 123 def 456")
    assert nil == RegexRs.captures(re, "abc abc abc abc")
  end

  test "captures_named/2" do
    {:ok, re} = RegexRs.new("c(?P<foo>d)")
    %{"foo" => "d"} = RegexRs.captures_named(re, "abcd")
    small_hit_str = "abc 123 def 456"

    {:ok, rust_named_capture_regex} = RegexRs.new("(?P<foo>\\d+)")
    assert %{"foo" => "123"} == RegexRs.captures_named(rust_named_capture_regex, small_hit_str)

    big_hit_str =
      Enum.reduce(1..1000, "", fn _val, acc ->
        "#{acc}#{small_hit_str}"
      end)

    assert %{"foo" => "123"} == RegexRs.captures_named(rust_named_capture_regex, big_hit_str)

    {:ok, rust_multi_named_capture_regex} = RegexRs.new("(?P<alpha>[a-z]+)\\s+(?P<digits>\\d+)")

    assert %{"alpha" => "abc", "digits" => "123"} ==
             RegexRs.captures_named(rust_multi_named_capture_regex, small_hit_str)

    assert %{"alpha" => "abc", "digits" => "123"} ==
             RegexRs.captures_named(rust_multi_named_capture_regex, big_hit_str)

    assert nil == RegexRs.captures_named(rust_multi_named_capture_regex, "nonmatchingstring")
  end

  test "captures_iter_named/2" do
    {:ok, re} = RegexRs.new(~r/(?P<letters>[a-z]+)\s+(?P<digits>\d+)/)

    assert [%{"digits" => "123", "letters" => "abc"}, %{"digits" => "456", "letters" => "def"}] =
             RegexRs.captures_iter_named(re, "abc 123 def 456")

    assert [] = RegexRs.captures_iter_named(re, "abc abc abc abc")
  end

  test "as_str/1" do
    regex_str = "(?P<alpha>[a-z]+)\\s+(?P<digits>\\d+)"
    {:ok, rust_multi_named_capture_regex} = RegexRs.new(regex_str)
    assert regex_str == RegexRs.as_str(rust_multi_named_capture_regex)
  end

  test "find_iter/2" do
    {:ok, re} = RegexRs.new("\\d+")
    assert ["12345"] = RegexRs.find_iter(re, "12345")
    assert ["12345", "66666"] = RegexRs.find_iter(re, "12345 66666")
    assert [] = RegexRs.find_iter(re, "abcde")
  end

  test "is_match/2" do
    {:ok, re} = RegexRs.new("\\d+")
    assert RegexRs.is_match(re, "12345")
    refute RegexRs.is_match(re, "abcde")
  end

  test "replace/3" do
    {:ok, re} = RegexRs.new("(?P<last>[^,\\s]+),\\s+(?P<first>\\S+)")
    assert "Bruce Springsteen" == RegexRs.replace(re, "Springsteen, Bruce", "$first $last")
    assert "Bruce_Springsteen" == RegexRs.replace(re, "Springsteen, Bruce", "${first}_$last")
    assert "Bruce Springsteen" == RegexRs.replace(re, "Springsteen, Bruce", "$2 $1")
    assert "234234902834" == RegexRs.replace(re, "234234902834", "$first $last")
    assert "" == RegexRs.replace(re, "", "$2 $1")
    {:ok, rust_replacement_regex} = RegexRs.new("(?P<letters>[a-z]+)\\s+(?P<digits>\\d+)")
    assert "123 abc" == RegexRs.replace(rust_replacement_regex, "abc 123", "$2 $1")
    assert "123 abc" == RegexRs.replace(rust_replacement_regex, "abc 123", "$digits $letters")
  end

  test "replace_all/3" do
    {:ok, re} = RegexRs.new("(?P<last>[^,\\s]+),\\s+(?P<first>\\S+)")

    assert "Bruce Springsteen Bruce Springsteen" ==
             RegexRs.replace_all(re, "Springsteen, Bruce Springsteen, Bruce", "$first $last")

    assert "Bruce_Springsteen Bruce_Springsteen" ==
             RegexRs.replace_all(re, "Springsteen, Bruce Springsteen, Bruce", "${first}_$last")

    assert "Bruce Springsteen Bruce Springsteen" ==
             RegexRs.replace_all(re, "Springsteen, Bruce Springsteen, Bruce", "$2 $1")

    assert "" == RegexRs.replace_all(re, "", "$first $last")
    assert "" == RegexRs.replace_all(re, "", "$2 $1")
    {:ok, rust_replacement_regex} = RegexRs.new("(?P<letters>[a-z]+)\\s+(?P<digits>\\d+)")

    assert "123 abc 456 def" ==
             RegexRs.replace_all(rust_replacement_regex, "abc 123 def 456", "$2 $1")

    assert "123 abc 456 def" ==
             RegexRs.replace_all(rust_replacement_regex, "abc 123 def 456", "$digits $letters")
  end
end
