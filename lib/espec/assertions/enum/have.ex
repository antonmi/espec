defmodule ESpec.Assertions.Enum.Have do

  @behaviour ESpec.Assertion

  def assert(enum, val, positive \\ true) do
    case match(enum, val) do
      {false, act} when positive ->
        raise ESpec.AssertionError, act: act, exp: val, message: error_message(enum, val, act, positive)
      {true, act} when not positive ->        
        raise ESpec.AssertionError, act: act, exp: val, message: error_message(enum, val, act, positive)
      _ -> :ok
    end
  end

  defp match(enum, val) do
    res = Enum.member?(enum, val) 
    {res, res}
  end

  def error_message(enum, val, act, positive) do
    to = if positive, do: "to", else: "to not"
    has = if act, do: "has", else: "has not"
    "Expected `#{inspect enum}` #{to} have `#{inspect val}`, but it #{has}."
  end

end
