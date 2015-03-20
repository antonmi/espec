defmodule ESpec.Expect do

  def expect(do: value) do
    {ESpec.To, value}
  end

  def expect(value) do
    {ESpec.To, value}
  end

  def eq(value) do
    {:eq, value}
  end

  def be(operator, value \\ nil) do
    {:be, operator,  value}
  end

  def be_between(min, max) do
    {:be, :between, [min, max]}
  end

  def raise_exception(), do: {:raise_exception, []}
  def raise_exception(exception, message), do: {:raise_exception, [exception, message]}
  def raise_exception(exception), do: {:raise_exception, [exception]}


end
