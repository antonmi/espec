defmodule ESpec.Docs.DocExampleTest do
  use ExUnit.Case, async: true
  alias TestModules.Docs.DocExample.{Mod1, Mod2}

  test "Mod1" do
    examples = ESpec.DocExample.extract(Mod1)
    assert length(examples) == 2

    ex = hd(examples)
    assert ex.lhs == "1 + 1"
    assert ex.rhs == "2"
    assert ex.fun_arity == {:f, 0}
  end

  test "Mod2" do
    assert_raise ESpec.DocExample.Error,
                 "indentation level mismatch: \"2\", should have been 2 spaces",
                 fn ->
                   ESpec.DocExample.extract(Mod2)
                 end
  end
end
