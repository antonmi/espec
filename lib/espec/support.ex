defmodule ESpec.Support do
  @moduledoc """
  Contains come function for generating random fucntion names.
  """

  @doc "Returns long random string."
  def random_string, do: "#{Enum.shuffle(97..122)}"

  @doc "Filters string keeping only word chars."
  def word_chars(string) do
    String.replace(string, ~r/[\W+\d+\s+]/, "_")
    |> String.downcase
  end
end
