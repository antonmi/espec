defmodule ESpec.Assertions.TupleFirstElement do
  use ESpec.Assertions.Interface

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