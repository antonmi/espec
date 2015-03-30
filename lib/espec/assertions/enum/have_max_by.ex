defmodule ESpec.Assertions.Enum.HaveMaxBy do

  @behaviour ESpec.Assertion

  def assert(enum, [func, val], positive \\ true) do
    case match(enum, func, val) do
      {false, act} when positive ->
        raise ESpec.AssertionError, act: act, exp: [func, val], message: error_message(enum, func, val, act, positive)
      {true, act} when not positive ->        
        raise ESpec.AssertionError, act: act, exp: [func, val], message: error_message(enum, func, val, act, positive)
      _ -> :ok
    end
  end

  defp match(enum, func, val) do
    act = Enum.max_by(enum, func)
    res = act == val
    {res, act}
  end

  def error_message(enum, func, val, act, positive) do
    to = if positive, do: "to be", else: "not to be"
    "Expected max value of `#{inspect enum}` using `#{inspect func}` #{to} `#{val}` but max is `#{act}`."
  end

end
