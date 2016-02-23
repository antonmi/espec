defmodule ESpec.Support do
  @moduledoc """
  Contains come function for generating random fucntion names.
  """

  @doc "Returns long random string."
  def random_string, do: "#{Enum.shuffle(97..122)}"

  @doc "Filters string replacing non-word characters by '_'."
  def word_chars(string) do
    string
    |> String.replace(~r/[\W+\d+\s+]/, "_")
    |> String.downcase
  end
end
