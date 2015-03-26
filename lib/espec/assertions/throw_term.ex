defmodule ESpec.Assertions.ThrowTerm do

  @behaviour ESpec.Assertion

  def assert(func, exp, positive \\ true) do
    case match(func, exp) do
      {false, []} when positive ->
        raise ESpec.AssertionError, act: func, exp: exp, message: error_message(func, exp, positive)
      {false, [term]} when positive ->
        raise ESpec.AssertionError, act: func, exp: exp, message: error_message(func, exp, term, positive)
      {false, _} -> nil
      true when positive ->
        nil
      true ->
        raise ESpec.AssertionError, act: func, exp: exp, message: error_message(func, exp, positive)
    end
  end

  defp match(func, []) do
    try do
      func.()
      {:false, []}
    catch
      term ->
        true
    end
  end

  defp match(func, [term]) do
    try do
      func.()
      {:false, []}
    catch
      t ->
        if t == term, do: true, else: {:false, [t]}
    end
  end


  defp error_message(func, [], positive) do
    if positive do
      "Expected #{inspect func} to throw term, but nothing was thrown"
    else
      "Expected #{inspect func} to not throw term, but a term was thrown"
    end
  end

  defp error_message(func, [exp_term], positive) do
    if positive do
      "Expected #{inspect func} to throw #{inspect exp_term}, but nothing was thrown"
    else
      "Expected #{inspect func} to not throw `#{inspect exp_term}`, but the term was thrown"
    end
  end

  defp error_message(func, [exp_term], term, positive) do
    "Expected #{inspect func} to throw `#{exp_term}`, but the `#{term}` term was thrown"
  end


end
