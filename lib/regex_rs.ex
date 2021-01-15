defmodule RegexRs do
  @moduledoc """
  Documentation for `RegexRs`.
  """
  use Rustler, otp_app: :regex_rs, crate: :regexrust

  def compile(_s), do: error()
  def run(_re, _s), do: error()
  def find_iter(_re, _s), do: error()
  def is_match(_re, _s), do: error()
  def named_captures(_re, _s), do: error()
  def source(_re), do: error()
  def replace(_re, _s, _replacement), do: error()
  def replace_all(_re, _s, _replacement), do: error()

  defp error() do
    :erlang.nif_error(:nif_not_loaded)
  end
end
