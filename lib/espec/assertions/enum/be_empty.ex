defmodule ESpec.Assertions.Enum.BeEmpty do

  @behaviour ESpec.Assertion

  def assert(enum, [], positive \\ true) do
    case match(enum) do
      {false, act} when positive ->
        raise ESpec.AssertionError, act: act, exp: 0, message: error_message(enum, act, positive)
      {true, act} when not positive ->        
        raise ESpec.AssertionError, act: act, exp: 0, message: error_message(enum, act, positive)
      _ -> :ok
    end
  end

  defp match(enum) do
    act = Enum.count(enum) 
    res = act == 0
    {res, act}
  end

  def error_message(enum, act, positive) do
    to = if positive, do: "to", else: "to not"
    has = if act, do: "has", else: "has not"
    "Expected `#{inspect enum}` #{to} be empty, but it #{has} `#{act}` elements."
  end

end
