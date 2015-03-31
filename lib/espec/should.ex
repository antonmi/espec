defmodule ESpec.Should do 
	@moduledoc """
  Defines `should` and `should_not` helpers.
  """

  @doc false
  defmacro __using__(_arg) do
    quote do
			@doc "The same as `subject |> should term )`"
      def should(term), do: ESpec.To.to(term, {ESpec.To, apply(__MODULE__, :subject, [])}, true)
      def should_not(term), do: ESpec.To.to(term, {ESpec.To, apply(__MODULE__, :subject, [])}, false)
    end
  end

  @doc "Wrapper for `ESpec.To`."
  def should(subject, term), do: ESpec.To.to(term, {ESpec.To, subject}, true)
  def should_not(subject, term), do: ESpec.To.to(term, {ESpec.To, subject}, false)
end
