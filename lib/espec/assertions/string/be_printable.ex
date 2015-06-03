defmodule ESpec.Assertions.String.BePrintable do

  use ESpec.Assertions.Interface

  defp match(string, _val) do
    result = String.printable?(string)
    {result, result}
  end

  defp success_message(string, _val, _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect string}` #{to} printable."
  end
  
  defp error_message(string, _val, _result, positive) do
    to = if positive, do: "to", else: "to not"
    but = if positive, do: "it isn't", else: "it is"
    "Expected `#{inspect string}` #{to} be printable but #{but}."
  end

end