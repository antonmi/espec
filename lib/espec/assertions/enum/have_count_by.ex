defmodule ESpec.Assertions.Enum.HaveCountBy do

  @behaviour ESpec.Assertion

  def assert(enum, [func, val], positive \\ true) do
    case match(enum, func, val) do
      {false, act} when positive ->
        raise ESpec.AssertionError, act: act, exp: val, message: error_message(enum, func, val, act, positive)
      {true, act} when not positive ->        
        raise ESpec.AssertionError, act: act, exp: val, message: error_message(enum, func, val, act, positive)
      _ -> :ok
    end
  end

  defp match(enum, func, val) do
    act = Enum.count(enum, func)
    res = act == val
    {res, act}
  end

  def error_message(enum, func, val, act, positive) do
    to = if positive, do: "to", else: "to not"
    "Expected `#{inspect enum}` #{to} have count_by `#{inspect func}` be equal to `#{val}` but has `#{act}`."
  end


end