defmodule MatchPatternTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    context "Success" do
      ESpec.Context.describe "ESpec.Assertions.MatchPattern" do
        it do: expect({:ok, 1}).to match_pattern({:ok, 1})
        it do: expect({:ok, 1}).to match_pattern({:ok, _})
        it do: expect( %{"foo" => :bar}).to match_pattern(%{"foo" => _bar})

        it do: expect({:ok, 1}).to_not match_pattern({:ok, 2})
        it do: expect({:ok, 1}).to_not match_pattern({:error, _})
        it do: expect(%{}).to_not match_pattern(%{"foo" => _bar})

        context "with pinned variables" do
          it do
            var = 1

            expect({:ok, 1}).to match_pattern({:ok, ^var})
          end

          it do
            pattern = {:ok, 1}

            expect({:ok, 1}).to match_pattern(^pattern)
          end
        end
      end
    end

    context "Errors" do
      it do: expect({:ok, 1}).to_not match_pattern({:ok, 1})
      it do: expect({:ok, 1}).to_not match_pattern({:ok, _})
      it do: expect(%{"foo" => :bar}).to_not match_pattern(%{"foo" => _bar})

      it do: expect({:ok, 1}).to match_pattern({:ok, 2})
      it do: expect({:ok, 1}).to match_pattern({:error, _})
      it do: expect(%{}).to match_pattern(%{"foo" => _bar})

      context "with pinned variables" do
        it do
          var = 1

          expect({:ok, 1}).to_not match_pattern({:ok, ^var})
        end

        it do
          pattern = {:ok, 1}

          expect({:ok, 1}).to_not match_pattern(^pattern)
        end
      end

      context "with let functions" do
        let foo: "bar"

        it do
          bar = :baz

          expect("bar") |> to(match_pattern foo())
        end
      end
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples, true)
    {:ok,
      success: Enum.slice(examples, 0, 8),
      errors: Enum.slice(examples, 9, 18)}
  end

  test "Success", context do
    Enum.each(context[:success], &(assert(&1.status == :success)))
  end

  test "Errors", context do
    Enum.each(context[:errors], &(assert(&1.status == :failure)))
  end
end
