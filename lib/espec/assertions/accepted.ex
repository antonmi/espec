defmodule ESpec.Assertions.Accepted do

  @behaviour ESpec.Assertion

  def assert(module, [func, args], positive \\ true) do
    unless success?(module, func, args, positive) do
      raise ESpec.AssertionError, act: func, exp: module, message: error_message(module, func, args, positive)
    end
  end

  defp success?(module, func, args, positive) do
    if positive, do: match(module, func, args), else: !match(module, func, args)
  end

  defp match(module, func, args) do
    pid = self()
    Enum.any?(:meck.history(module), fn(el) ->
      case el do
        {^pid, {^module, ^func, ^args}, _return} -> true
        _ -> false
      end
    end)
  end

  def error_message(module, func, args, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{module}` #{to} accept `#{func}` with `#{inspect args}`"
  end

end
