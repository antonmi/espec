defmodule ESpec.Assertions.TupleFirstElement do
  use ESpec.Assertions.Interface

  @moduledoc """
  Defines 'be_ok' and 'be_error' assertions.

  Matches the first element of a tuple.

  it do: expect({:ok, ...}) |> to(be_ok)
  it do: expect({:error, ...}) |> to(be_error)
  """

  defp match(subject, expected) when is_tuple(subject) do
    element = elem subject, 0
    {element == expected, element}
  end

  defp success_message _subject, expected, actual, positive do
    to = if positive, do: "equals", else: "doesn't equal"
    "`#{inspect expected}` #{to} `#{inspect actual}`"
  end

  defp error_message _subject, expected, actual, positive do
    to = if positive, do: "to", else: "not to"
    "Expected `{#{inspect actual}, ...}` #{to} equal `{#{inspect expected}, ...}`"
  end
end