defmodule ESpec.Assertions.MatchPattern do
  @moduledoc """
  Defines 'match_pattern' (=) assertion.

  it do: expect(actual).to match_pattern(expected)
  """
  use ESpec.Assertions.Interface

  defp match(subject, [pattern, env, vars]) do
    pattern = Macro.expand(pattern, env)
    vars =
      for {key, value} <- vars do
        quote do: unquote(Macro.var(key, nil)) = unquote(Macro.escape(value))
      end

    result_quote =
      quote do
        import unquote(env.module)

        unquote_splicing(vars)

        match?(unquote(pattern), unquote(Macro.escape(subject)))
      end

    {result, _} = Code.eval_quoted(result_quote)

    {result, result}
  end

  defp success_message(subject, [pattern, _env, _vars], _result, positive) do
    data = Macro.to_string(pattern)
    to = if positive, do: "matches", else: "doesn't match"
    "`#{inspect subject}` #{to} pattern (=) `#{data}`."
  end

  defp error_message(subject, [pattern, _env, _vars], _result, positive) do
    data = Macro.to_string(pattern)
    to = if positive, do: "to", else: "not to"
    but = if positive, do: "doesn't", else: "does"
    "Expected `#{inspect subject}` #{to} match pattern (=) `#{data}`, but it #{but}."
  end
end
