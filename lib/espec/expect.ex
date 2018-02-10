defmodule ESpec.Expect do
  @moduledoc """
  Defines `expect` and `is_expected` helper functions.
  These functions wrap arguments for ESpec.ExpectTo module.
  """

  alias ESpec.ExpectTo

  @doc false
  defmacro __using__(_arg) do
    quote do
      @doc "The same as `expect(subject)`"
      def is_expected do
        {ESpec.ExpectTo, apply(__MODULE__, :subject, []), pruned_stacktrace()}
      end
    end
  end

  @doc "Wrapper for `ESpec.ExpectTo`."
  def expect(do: value), do: {ExpectTo, value, pruned_stacktrace()}
  def expect(value), do: {ExpectTo, value, pruned_stacktrace()}

  def pruned_stacktrace() do
    {:current_stacktrace, trace} = Process.info(self(), :current_stacktrace)
    prune_stacktrace(trace)
  end

  # stop at the example runner
  defp prune_stacktrace([{ESpec.ExampleRunner, _, _, _} | _rest]), do: []

  # ignore these
  defp prune_stacktrace([{Process, :info, _, _} | rest]), do: prune_stacktrace(rest)
  defp prune_stacktrace([{_, :is_expected, 0, _} | rest]), do: prune_stacktrace(rest)
  defp prune_stacktrace([{_, :should, 1, _} | rest]), do: prune_stacktrace(rest)
  defp prune_stacktrace([{_, :should_not, 1, _} | rest]), do: prune_stacktrace(rest)
  defp prune_stacktrace([{ESpec.Should, :should, 2, _} | rest]), do: prune_stacktrace(rest)
  defp prune_stacktrace([{ESpec.Should, :should_not, 2, _} | rest]), do: prune_stacktrace(rest)
  defp prune_stacktrace([{ESpec.To, :to, 2, _} | rest]), do: prune_stacktrace(rest)
  defp prune_stacktrace([{ESpec.To, :not_to, 2, _} | rest]), do: prune_stacktrace(rest)
  defp prune_stacktrace([{ESpec.To, :to_not, 2, _} | rest]), do: prune_stacktrace(rest)
  defp prune_stacktrace([{ESpec.Expect, :expect, _, _} | rest]), do: prune_stacktrace(rest)
  defp prune_stacktrace([{ESpec.Expect, :pruned_stacktrace, 0, _} | rest]), do: prune_stacktrace(rest)
  defp prune_stacktrace([{ESpec.Expect, :prune_stacktrace, 2, _} | rest]), do: prune_stacktrace(rest)

  defp prune_stacktrace([h | t]), do: [h | prune_stacktrace(t)]
  defp prune_stacktrace([]), do: []
end
