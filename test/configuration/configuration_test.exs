defmodule ConfigurationTest do
  use ExUnit.Case, async: true

  test "configure function" do
    ESpec.configure(fn c ->
      c.test(:ok)
    end)

    assert(ESpec.Configuration.get(:test) == :ok)
  end

  test "allows only whitelistet functions" do
    assert_raise(UndefinedFunctionError, fn ->
      ESpec.configure(fn c -> c.hey(:ok) end)
    end)
  end
end
