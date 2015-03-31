defmodule ESpec.Assertions.RaiseException do

  use ESpec.Assertion

  defp match(subject, []) do
    try do
      subject.()
      {false, false}
    rescue
      _error -> {true, false}
    end
  end

  defp match(subject, [module]) do
    try do
      subject.()
      {false, {false, nil}}
    rescue
      error ->
        if error.__struct__ == module do
          {true, {false, error.__struct__}}
        else
          {false, {false, error.__struct__}}
        end
    end
  end

  defp match(subject, [module, mes]) do
    try do
      subject.()
      {false, false}
    rescue
      error ->
        if error.__struct__ == module && Exception.message(error) == mes do
          {true, true}
        else
          {false, [error.__struct__, Exception.message(error)]}
        end
    end
  end

  defp error_message(subject, [], false, positive) do
    if positive do
      "Expected #{inspect subject} to raise exception, but nothing was raised"
    else
      "Expected #{inspect subject} to not raise exception, but an exception was raised"
    end
  end

  defp error_message(subject, [module], {false, err_module}, positive) do
    if positive do
      "Expected #{inspect subject} to raise exception `#{module}`, but nothing was raised"
    else
      "Expected #{inspect subject} to not raise exception `#{module}`, but the exception `#{err_module}` was raised"
    end
  end

  defp error_message(subject, [module, message], false, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected #{inspect subject} #{to} raise exception `#{module}` with message `#{message}`, but nothing was raised"
  end

  defp error_message(subject, [module], [err_module], _positive) do
    "Expected #{inspect subject} to raise exception `#{module}`, but `#{err_module}` was raised"
  end

  defp error_message(subject, [module, message], [err_module, err_message], _positive) do
    "Expected #{inspect subject} to raise exception `#{module}` with message `#{message}`, but `#{err_module}` was raised with the message `#{err_message}`"
  end

end
