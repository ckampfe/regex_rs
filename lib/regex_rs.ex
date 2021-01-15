defmodule RegexRs do
  @moduledoc """
  Documentation for `RegexRs`.
  """
  use Rustler, otp_app: :regex_rs, crate: :regexrust

  @doc ~S"""
  Compiles the regular expression.

  ## Examples

      iex> {:ok, _reference} = RegexRs.compile(~r/\d+/); nil
      nil

      iex> {:ok, _reference} = RegexRs.compile("\\d+"); nil
      nil

      iex> {:error, _error} = RegexRs.compile("\\y"); nil
      nil

  """
  def compile(re = %Regex{}), do: compile_internal(Regex.source(re))
  def compile(string) when is_binary(string), do: compile_internal(string)
  defp compile_internal(_string), do: error()

  @doc ~S"""
  Runs the regular expression against the given string until the first match. It
  returns a list with all captures or an empty list if no match occurred.


  ## Examples

      iex> {:ok, re} = RegexRs.compile("[a-z]+\\s+\(\\d+\)")
      iex> RegexRs.run(re, "abc 123 def 456")
      ["abc 123", "123"]
      iex> RegexRs.run(re, "abc abc abc abc")
      []
  """
  def run(_re, _string), do: error()

  @doc ~S"""


  ## Examples
  Like `run/2`, but scans the target several times collecting all matches of the
  regular expression. Does not show captures. For captures, see `captures_iter/2`.

      iex> {:ok, re} = RegexRs.compile("\\d+")
      iex> RegexRs.scan(re, "12345 678910")
      ["12345", "678910"]
      iex> RegexRs.scan(re, "abcde")
      []
  """
  def scan(_re, _string), do: error()

  @doc ~S"""
  Returns a boolean indicating whether there was a match or not.

  ## Examples

      iex> {:ok, re} = RegexRs.compile("\\d+"); nil
      nil
      iex> RegexRs.is_match(re, "12345")
      true
      iex> RegexRs.is_match(re, "xxxxx")
      false
  """
  def is_match(_re, _string), do: error()

  @doc ~S"""
  Returns the given captures as a map, or an empty map if no captures are found.

  ## Examples

      iex> {:ok, re} = RegexRs.compile("c(?P<foo>d)"); nil
      nil
      iex> RegexRs.named_captures(re, "abcd")
      %{"foo" => "d"}

      iex> {:ok, re} = RegexRs.compile("(?P<alpha>[a-z]+)\\s+(?P<digits>\\d+)"); nil
      nil
      iex> RegexRs.named_captures(re, "abc 123 def 456")
      %{"alpha" => "abc", "digits" => "123"}
  """
  def named_captures(_re, _string), do: error()

  @doc ~S"""
  From the Rust `regex` docs:
  Replaces the leftmost-first match with the replacement provided. The replacement
  can be a regular string (where $N and $name are expanded to match capture groups)
  or a function that takes the matches' Captures and returns the replaced string.
  If no match is found, then a copy of the string is returned unchanged.
  See: https://docs.rs/regex/1.4.3/regex/struct.Regex.html#method.replace

  ## Examples

      iex> {:ok, re} = RegexRs.compile("(?P<last>[^,\\s]+),\\s+(?P<first>\\S+)"); nil
      nil
      iex> RegexRs.replace(re, "Springsteen, Bruce", "$first $last")
      "Bruce Springsteen"
      iex> RegexRs.replace(re, "Springsteen, Bruce", "${first}_$last")
      "Bruce_Springsteen"
      iex> RegexRs.replace(re, "Springsteen, Bruce", "$2 $1")
      "Bruce Springsteen"
      iex> RegexRs.replace(re, "234234902834", "$first $last")
      "234234902834"
  """
  def replace(_re, _string, _replacement), do: error()

  @doc ~S"""
  Replaces all non-overlapping matches in text with the replacement provided.
  Obeys the same conventions as `replace/3`.
  See: https://docs.rs/regex/1.4.3/regex/struct.Regex.html#method.replace_all

  ## Examples

      iex> {:ok, re} = RegexRs.compile("(?P<letters>[a-z]+)\\s+(?P<digits>\\d+)")
      iex> RegexRs.replace_all(re, "abc 123 def 456", "$digits $letters")
      "123 abc 456 def"
      iex> RegexRs.replace_all(re, "abc abc abc abc", "$digits $letters")
      "abc abc abc abc"
  """
  def replace_all(_re, _string, _replacement), do: error()

  @doc ~S"""
  Returns the regex source as a binary.

  ## Examples

      iex> {:ok, re} = RegexRs.compile("\\d+"); nil
      nil
      iex> RegexRs.source(re)
      "\\d+"
  """
  def source(_re), do: error()

  defp error() do
    :erlang.nif_error(:nif_not_loaded)
  end
end
