defmodule ESpec.SomeModule do
  def f, do: :f
  def m, do: :m

  def fun(a, b), do: a + b

  def calc, do: (1..1000000) |> Enum.shuffle |> Enum.sort |> List.first
end
