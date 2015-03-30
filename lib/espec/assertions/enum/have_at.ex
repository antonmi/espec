defmodule ESpec.Assertions.Enum.HaveAt do

  @behaviour ESpec.Assertion

  def assert(enum, [pos, val], positive \\ true) do
    case match(enum, pos, val) do
      {false, act} when positive ->
        raise ESpec.AssertionError, act: act, exp: val, message: error_message(enum, pos, val, act, positive)
      {true, act} when not positive ->        
        raise ESpec.AssertionError, act: act, exp: val, message: error_message(enum, pos, val, act, positive)
      _ -> :ok
    end
  end

  defp match(enum, pos, val) do
    act = Enum.at(enum, pos) 
    res = act == val
    {res, act}
  end

  def error_message(enum, pos, val, act, positive) do
    to = if positive, do: "to", else: "to not"
    "Expected `#{inspect enum}` #{to} have `#{inspect val}` on `#{inspect pos}` position, but it has `#{act}`."
  end

end
