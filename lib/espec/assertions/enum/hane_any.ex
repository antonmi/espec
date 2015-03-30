defmodule ESpec.Assertions.Enum.HaveAny do

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
    res = Enum.any?(enum, func)
    {res, res}
  end

  def error_message(enum, func, act, positive) do
    to = if positive, do: "to", else: "to not"
    "Expected `#{inspect func}` #{to} return `true` for at least one element in `#{inspect enum}` but returns `#{act}` for all."
  end

end
