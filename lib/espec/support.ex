defmodule ESpec.Support do

  def random_string, do: "#{Enum.shuffle(97..122)}"

  def word_chars(string) do
    String.replace(string, ~r/[\W+\d+\s+]/, "_")
  end
end
