defmodule ESpec.DocTest.ExceptSpec do
  use ESpec
  doctest TestModules.Docs.DocTestModules.Mod2, except: [f2: 0, f3: 0]
end
|> ExUnit.TestHelpers.write_beam()

defmodule ESpec.DocTest.OnlySpec do
  use ESpec
  doctest TestModules.Docs.DocTestModules.Mod2, only: [f2: 0, f3: 0]
end
|> ExUnit.TestHelpers.write_beam()

defmodule ESpec.DocTest.ExceptWithOnlySpec do
  use ESpec
  doctest TestModules.Docs.DocTestModules.Mod2, only: [f2: 0, f3: 0], except: [f2: 0]
end
|> ExUnit.TestHelpers.write_beam()

defmodule ESpec.Docs.ExcepAndOnlyTest do
  use ExUnit.Case, async: true

  test "check except examples" do
    examples = ESpec.DocTest.ExceptSpec.examples()
    assert length(examples) == 2
    ex1 = List.first(examples)
    assert ex1.description == "Doctest for Elixir.TestModules.Docs.DocTestModules.Mod2.f1/0 (0)"
    ex2 = List.last(examples)
    assert ex2.description == "Doctest for Elixir.TestModules.Docs.DocTestModules.Mod2.f4/0 (1)"
  end

  test "check only examples" do
    examples = ESpec.DocTest.OnlySpec.examples()
    assert length(examples) == 2
    ex1 = List.first(examples)
    assert ex1.description == "Doctest for Elixir.TestModules.Docs.DocTestModules.Mod2.f2/0 (0)"
    ex2 = List.last(examples)
    assert ex2.description == "Doctest for Elixir.TestModules.Docs.DocTestModules.Mod2.f3/0 (1)"
  end

  test "check exept with only examples" do
    examples = ESpec.DocTest.ExceptWithOnlySpec.examples()
    assert length(examples) == 1
    ex1 = List.first(examples)
    assert ex1.description == "Doctest for Elixir.TestModules.Docs.DocTestModules.Mod2.f3/0 (0)"
  end
end
