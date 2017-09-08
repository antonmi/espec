defmodule MatchPatternTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    context "Success" do
      ESpec.Context.describe "ESpec.Assertions.MatchPattern" do
        it do: expect({:ok, 1}).to match_pattern({:ok, 1})
        it do: expect({:ok, 1}).to match_pattern({:ok, _})

        it do: expect({:ok, 1}).to_not match_pattern({:ok, 2})
        it do: expect({:ok, 1}).to_not match_pattern({:error, _})

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

      it do: expect({:ok, 1}).to match_pattern({:ok, 2})
      it do: expect({:ok, 1}).to match_pattern({:error, _})

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
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples, true)
    {:ok,
      success: Enum.slice(examples, 0, 6),
      errors: Enum.slice(examples, 7, 13)}
  end

  test "Success", context do
    Enum.each(context[:success], &(assert(&1.status == :success)))
  end

  test "Errors", context do
    Enum.each(context[:errors], &(assert(&1.status == :failure)))
  end
end
