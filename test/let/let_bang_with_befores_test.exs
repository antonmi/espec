defmodule LetBangWithBeforesTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec
    context "forces evaluation before examples" do
      let! :test do
        Application.put_env(:espec, :letbang_value, "let!")
        456
      end

      it "has run before example" do
        value = Application.get_env(:espec, :letbang_value, "")
        expect value |> to(eq "let!")
        expect test() |> to(eq 456)
      end

      context "when overridden, is used by before" do
        let! :test, do: "initial"

        before do
          expect test() |> to(eq "overridden")
        end

        context "some context" do
          let! :test do
            Application.put_env(:espec, :letbang_value, "let2!")
            "overridden"
          end

          it "equals 131" do
            expect test() |> to(eq "overridden")
          end
        end
      end
    end
  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0),
      ex2: Enum.at(SomeSpec.examples, 1),
    }
  end

  test "run ex1", context do
    example = ESpec.ExampleRunner.run(context[:ex1])
    assert(example.status == :success)
  end

  test "run ex2", context do
    example = ESpec.ExampleRunner.run(context[:ex2])
    assert(example.status == :success)
  end
end
