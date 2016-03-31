defmodule Let.AstParserTest do
  use ExUnit.Case, async: true
  alias ESpec.Let.AstParser

  def simplest_ast do
    quote do: 1 + 1
  end

  def simple_ast do
    quote do: SomeModule.fun(1, 2)
  end

  def simple_ast_2 do
    quote do
      1 + 1
      SomeModule.fun(1, 2)
    end
  end

  def ordinary_ast do
    quote do
      Enum.reduce(%{1 => 2, 3 => 4}, [], fn({k, v}, acc) -> k * v end)
    end
  end

  def ordinary_ast_2 do
    quote do
      defmodule M do
        def fun(a) do
          a * 2
        end
      end
      def func do
        a * 3
      end
      defmacro macro do
        a * 4
      end
      M.fun(2)
    end
  end

  def ast_with_pipe do
    quote do
      a |> SomeModule.should(eq 1)
      a |> should(eq 2)
    end
  end

  def ast_with_pipe_2 do
    quote do
      a |> should(eq([1] |> List.first))
    end
  end

  def spec_ast do
    quote do
      it "test" do
        a |> should(eq 1)
        should(a, eq 1)
        a |> should(eq([1] |> List.first))
      end
    end
  end


  test "simplest ast" do
    fun_list = AstParser.function_list(simplest_ast)
    assert fun_list == ["Elixir.Let.AstParserTest.+/2"]
  end

  test "simple_ast" do
    fun_list = AstParser.function_list(simple_ast)
    assert fun_list == ["SomeModule.fun/2"]
  end

  test "simple_ast_2" do
    fun_list = AstParser.function_list(simple_ast_2)
    assert fun_list == ["SomeModule.fun/2", "Elixir.Let.AstParserTest.+/2"]
  end

  test "ordinary ast" do
    fun_list = AstParser.function_list(ordinary_ast)
    assert fun_list == ["Enum.reduce/3", "Elixir.Let.AstParserTest.*/2", "v/0", "k/0", "%{}/2"]
  end

  test "ordinary_ast_2" do
    fun_list = AstParser.function_list(ordinary_ast_2)
    assert fun_list == ["M.fun/1"]
  end

  test "ast_with_pipe" do
    fun_list = AstParser.function_list(ast_with_pipe)
    assert fun_list ==["should/2", "eq/1", "a/0", "SomeModule.should/2"]
  end

  test "ast_with_pipe_2" do
    fun_list = AstParser.function_list(ast_with_pipe_2)
    assert fun_list == ["should/2", "eq/1", "List.first/1", "a/0"]
  end

  test "spec_ast" do
    fun_list = AstParser.function_list(spec_ast)
    assert fun_list == ["it/2", "should/2", "eq/1", "List.first/1", "a/0"]
  end
end
