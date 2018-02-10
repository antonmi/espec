defmodule ESpec.Should do
  @moduledoc """
  Defines `should` and `should_not` helpers.
  """

  alias ESpec.ExpectTo
  alias ESpec.Expect

  @doc false
  defmacro __using__(_arg) do
    quote do
      @doc "The same as `subject |> should term )`"
      def should(term), do: ExpectTo.to(term, {ExpectTo, apply(__MODULE__, :subject, []), Expect.pruned_stacktrace()})
      def should_not(term), do: ExpectTo.to_not(term, {ExpectTo, apply(__MODULE__, :subject, []), Expect.pruned_stacktrace()})
    end
  end

  @doc "Wrapper for `ESpec.ExpectTo`."
  def should(subject, term), do: ExpectTo.to(term, {ExpectTo, subject, Expect.pruned_stacktrace()})
  def should_not(subject, term), do: ExpectTo.to_not(term, {ExpectTo, subject, Expect.pruned_stacktrace()})
end
