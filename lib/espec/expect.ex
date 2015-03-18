defmodule Espec.Expect do

  def expect(do: value) do
    {Espec.To, value}
  end

  def expect(value) do
    {Espec.To, value}
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

end
