defmodule ESpec.Should do
  @moduledoc """
  Defines `should` and `should_not` helpers.
  """

  @doc false
  defmacro __using__(_arg) do
    quote do
      @doc "The same as `subject |> should term )`"
      def should(term), do: ESpec.ExpectTo.to(term, {ESpec.ExpectTo, apply(__MODULE__, :subject, [])})
      def should_not(term), do: ESpec.ExpectTo.to_not(term, {ESpec.ExpectTo, apply(__MODULE__, :subject, [])})
    end
  end

  @doc "Wrapper for `ESpec.ExpectTo`."
  def should(subject, term), do: ESpec.ExpectTo.to(term, {ESpec.ExpectTo, subject})
  def should_not(subject, term), do: ESpec.ExpectTo.to_not(term, {ESpec.ExpectTo, subject})
end
