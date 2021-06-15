defmodule RegexRs do
  @moduledoc """
  Documentation for `RegexRs`.
  See Rust documentation for more information: https://docs.rs/regex/1.4.3/regex/index.html

  Implemented so far:
  - [x] as_str
  - [ ] capture_locations
  - [x] capture_names
  - [x] captures (+ _named)
  - [x] captures_iter (+ _named)
  - [x] captures_len
  - [ ] captures_read
  - [ ] catpures_read_at
  - [x] find
  - [ ] find_at
  - [x] find_iter
  - [x] is_match
  - [ ] is_match_at
  - [x] new
  - [x] replace
  - [x] replace_all
  - [ ] replacen
  - [ ] shortest_match
  - [ ] shortest_match_at
  - [ ] split
  - [ ] splitn
  """

  use Rustler,
    otp_app: :regex_rs,
    crate: :regexrust

  @doc ~S"""
  Compiles the regular expression.
  Takes an existing Elixir `Regex` or a string that has been properly escaped.

  ## Examples

      iex> {:ok, _reference} = RegexRs.new(~r/\d+/); nil
      nil

      iex> {:ok, _reference} = RegexRs.new(Regex.compile!("\\d+")); nil
      nil

      iex> {:ok, _reference} = RegexRs.new("\\d+"); nil
      nil

      iex> {:error, _error} = RegexRs.new("\\y"); nil
      nil

  """
  def new(re = %Regex{}), do: new_internal(Regex.source(re))
  def new(string) when is_binary(string), do: new_internal(string)
  defp new_internal(_string), do: error()

  @doc ~S"""
  Runs the regular expression against the given string until the first match. It
  returns a list with all captures or nil no match occurred.


  ## Examples

      iex> {:ok, re} = RegexRs.new("[a-z]+\\s+\(\\d+\)")
      iex> RegexRs.captures(re, "abc 123 def 456")
      ["abc 123", "123"]
      iex> RegexRs.captures(re, "abc abc abc abc")
      nil
  """
  def captures(_re, _string), do: error()

  @doc ~S"""
  Returns the given captures as a map, or nil if no captures are found.

  ## Examples

      iex> {:ok, re} = RegexRs.new(~r/c(?P<foo>d)/); nil
      nil
      iex> RegexRs.captures_named(re, "abcd")
      %{"foo" => "d"}

      iex> {:ok, re} = RegexRs.new("(?P<alpha>[a-z]+)\\s+(?P<digits>\\d+)"); nil
      nil
      iex> RegexRs.captures_named(re, "abc 123 def 456")
      %{"alpha" => "abc", "digits" => "123"}
      iex> RegexRs.captures_named(re, "zzzzzzzzzzz")
      nil
  """
  def captures_named(_re, _string), do: error()

  @doc ~S"""
  Returns the number of captures.

  ## Examples

      iex> {:ok, re} = RegexRs.new(~r/\d+/); nil
      nil
      iex> RegexRs.captures_len(re)
      1

      iex> {:ok, re} = RegexRs.new(~r/(?P<alpha>[a-z]+)\s+(?P<digits>\d+)/); nil
      nil
      iex> RegexRs.captures_len(re)
      3
  """
  def captures_len(_re), do: error()

  @doc ~S"""
  Returns a list of the capture names.
  Unnamed captures will always be represented by the string "unnamed_capture".
  The capture representing the entire expression will always be unnamed,
  and will always be at position 0.

  ## Examples

      iex> {:ok, re} = RegexRs.new(~r/(?P<alpha>[a-z]+)\s+(?P<digits>\d+)/); nil
      nil
      iex> RegexRs.capture_names(re)
      ["unnamed_capture", "alpha", "digits"]
  """
  def capture_names(_re), do: error()

  @doc ~S"""
  Returns the given captures as a list of lists, or an empty list if no captures are found.

  ## Examples

      iex> {:ok, re} = RegexRs.new(~r/(?P<letters>[a-z]+)\s+(?P<digits>\d+)/); nil
      nil
      iex> RegexRs.captures_iter(re, "abc 123 def 456")
      [["abc 123", "abc", "123"], ["def 456", "def", "456"]]
      iex> RegexRs.captures_iter(re, "abc abc abc abc")
      []
  """
  def captures_iter(_re, _string), do: error()

  @doc ~S"""
  Returns the given captures as a list of maps, or an empty list if no captures are found.

  ## Examples

      iex> {:ok, re} = RegexRs.new(~r/(?P<letters>[a-z]+)\s+(?P<digits>\d+)/); nil
      nil
      iex> RegexRs.captures_iter_named(re, "abc 123 def 456")
      [%{"digits" => "123", "letters" => "abc"}, %{"digits" => "456", "letters" => "def"}]
      iex> RegexRs.captures_iter_named(re, "abc abc abc abc")
      []
  """
  def captures_iter_named(_re, _string), do: error()

  @doc ~S"""
  Returns the leftmost match in text. If no match exists, then nil is returned.
  Note that this should only be used if you want to discover the position of the match.
  Testing the existence of a match is faster if you use is_match.

  ## Examples

      iex> {:ok, re} = RegexRs.new("[a-z]+\\s+\(\\d+\)")
      iex> RegexRs.find(re, "abc 123 def 456")
      "abc 123"
      iex> RegexRs.find(re, "abc abc abc abc")
      nil
  """
  def find(_re, _string), do: error()

  @doc ~S"""
  Runs the regular expression against the given string until the first match. It
  returns a list with all captures or an empty list if no match occurred.

  ## Examples

      iex> {:ok, re} = RegexRs.new(~r/\d+/)
      iex> RegexRs.find_iter(re, "12345 678910")
      ["12345", "678910"]
      iex> RegexRs.find_iter(re, "abcde")
      []
  """
  def find_iter(_re, _string), do: error()

  @doc ~S"""
  Returns a boolean indicating whether there was a match or not.

  ## Examples

      iex> {:ok, re} = RegexRs.new(~r/\d+/); nil
      nil
      iex> RegexRs.is_match(re, "12345")
      true
      iex> RegexRs.is_match(re, "xxxxx")
      false
  """
  def is_match(_re, _string), do: error()

  @doc ~S"""
  From the Rust `regex` docs:
  Replaces the leftmost-first match with the replacement provided. The replacement
  can be a regular string (where $N and $name are expanded to match capture groups)
  or a function that takes the matches' Captures and returns the replaced string.
  If no match is found, then a copy of the string is returned unchanged.
  See: https://docs.rs/regex/1.4.3/regex/struct.Regex.html#method.replace

  ## Examples

      iex> {:ok, re} = RegexRs.new("(?P<last>[^,\\s]+),\\s+(?P<first>\\S+)"); nil
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

      iex> {:ok, re} = RegexRs.new("(?P<letters>[a-z]+)\\s+(?P<digits>\\d+)")
      iex> RegexRs.replace_all(re, "abc 123 def 456", "$digits $letters")
      "123 abc 456 def"
      iex> RegexRs.replace_all(re, "abc abc abc abc", "$digits $letters")
      "abc abc abc abc"
  """
  def replace_all(_re, _string, _replacement), do: error()

  @doc ~S"""
  Returns the regex source as a binary.

  ## Examples

      iex> {:ok, re} = RegexRs.new(~r/\d+/); nil
      nil
      iex> RegexRs.as_str(re)
      "\\d+"
  """
  def as_str(_re), do: error()

  defp error() do
    :erlang.nif_error(:nif_not_loaded)
  end
end
