defmodule ESpec.Support do
  @moduledoc """
  Contains come functions for generating random function names.
  """

  @doc "Returns long random string."
  def random_string, do: "#{Enum.shuffle(97..122)}"

  @doc "Filters string replacing non-word characters by '_'."
  def word_chars(string) do
    string
    |> remove_unicode
    |> String.replace(~r/[\W+\d+\s+]/, "_")
    |> String.downcase
  end

  defp remove_unicode(string) do
    string
    |> String.normalize(:nfd)
    |> String.replace(~r/[^A-z\s]/u, "")
  end
end
