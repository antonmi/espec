defmodule ESpec.Assertions.Enum.HaveAll do

  @behaviour ESpec.Assertion

  def assert(enum, func, positive \\ true) do
    case match(enum, func) do
      {false, act} when positive ->
        raise ESpec.AssertionError, act: act, exp: true, message: error_message(enum, func, act, positive)
      {true, act} when not positive ->        
        raise ESpec.AssertionError, act: act, exp: false, message: error_message(enum, func, act, positive)
      _ -> :ok
    end
  end

  defp match(enum, func) do
    res = Enum.all?(enum, func)
    {res, res}
  end

  def error_message(enum, func, act, positive) do
    to = if positive, do: "to", else: "to not"
    "Expected `#{inspect func}` #{to} return true for all elements in `#{inspect enum}`, but returts `#{act}` for some."
  end


end