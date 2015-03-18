defmodule EspecTest do
  use ExUnit.Case
  doctest Espec

  setup context do

    {:ok, a: :b}
  end


  setup context do

    {:ok, b: :c}
  end


  test "the truth", context do
    IO.puts(inspect context)
    assert context[:a] == :b
    assert context[:b] == :c
  end
end
