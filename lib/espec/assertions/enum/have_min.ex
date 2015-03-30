defmodule ESpec.Assertions.Enum.HaveMin do

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
    act = Enum.min(enum)
    res = act == val
    {res, act}
  end

  def error_message(enum, val, act, positive) do
    to = if positive, do: "to be", else: "not to be"
    "Expected minimum value of `#{inspect enum}` #{to} `#{val}` but minimum is `#{act}`."
  end

end
