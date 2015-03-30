defmodule ESpec.Assertions.RaiseException do

  @behaviour ESpec.Assertion

  def assert(func, exp, positive \\ true) do
    case match(func, exp) do
      {false, []} when positive ->
        raise ESpec.AssertionError, act: func, exp: exp, message: error_message(func, exp, positive)
      {false, [err_module]} when positive ->
        raise ESpec.AssertionError, act: func, exp: exp, message: error_message(func, exp, err_module, positive)
      {false, [err_module, err_message]} when positive ->
        raise ESpec.AssertionError, act: func, exp: exp, message: error_message(func, exp, err_module, err_message, positive)
      {false, _} -> nil
      true when positive ->
        :ok
      true ->
        raise ESpec.AssertionError, act: func, exp: exp, message: error_message(func, exp, positive)
    end
  end

  defp match(func, []) do
    try do
      func.()
      {:false, []}
    rescue
      _error ->
        true
    end
  end

  defp match(func, [module]) do
    try do
      func.()
      {:false, []}
    rescue
      error ->
        if error.__struct__ == module, do: true, else: {:false, [error.__struct__]}
    end
  end

  defp match(func, [module, mes]) do
    try do
      func.()
      {:false, []}
    rescue
      error ->
        if error.__struct__ == module && Exception.message(error) == mes do
          true
        else
          {:false, [error.__struct__, Exception.message(error)]}
        end
    end
  end

  defp error_message(func, [], positive) do
    if positive do
      "Expected #{inspect func} to raise exception, but nothing was raised"
    else
      "Expected #{inspect func} to not raise exception, but an exception was raised"
    end
  end

  defp error_message(func, [module], positive) do
    if positive do
      "Expected #{inspect func} to raise exception `#{module}`, but nothing was raised"
    else
      "Expected #{inspect func} to not raise exception `#{module}`, but the exception was raised"
    end
  end

  defp error_message(func, [module, message], positive) do
    to = if positive, do: "to", else: "not to"
    "Expected #{inspect func} #{to} raise exception `#{module}` with message `#{message}`, but nothing was raised"
  end

  defp error_message(func, [module], err_module, _positive) do
    "Expected #{inspect func} to raise exception `#{module}`, but `#{err_module}` was raised"
  end

  defp error_message(func, [module, message], err_module, err_message, _positive) do
    "Expected #{inspect func} to raise exception `#{module}` with message `#{message}`, but `#{err_module}` was raised with the message `#{err_message}`"
  end

end
