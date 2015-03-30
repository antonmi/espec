defmodule ESpec.Assertions.ThrowTerm do
  
  use ESpec.Assertion

  defp match(subject, []) do
    try do
      subject.()
      {:false, :false}
    catch
      _term -> {:true, :true}
    end
  end

  defp match(subject, [term]) do
    try do
      subject.()
      {:false, :false}
    catch
      t -> if t == term, do: {true, term}, else: {:false, t}
    end
  end

  defp error_message(subject, data, :false, positive) do
    to = if positive, do: "to", else: "to not"
    but = if positive, do: "nothing was thrown", else: "a term was thrown"
    "Expected `#{inspect subject}` #{to} throw term, but #{but}."
  end

  defp error_message(subject, [exp_term], term, positive) do
    to = if positive, do: "to", else: "to not"
    but = if positive, do: "nothing was thrown", else: "the `#{term}` was thrown"
    "Expected `#{inspect subject}` to throw #{inspect exp_term}, but `#{but}`."
  end

  defp error_message(subject, [exp_term], term, _positive) do
    "Expected `#{inspect subject}` to throw `#{inspect exp_term}`, but the `#{inspect term}` term was thrown."
  end


end
