defmodule Calendar.BeTimedTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    context "Success" do
      context "for Time subject" do
        it do: expect(~T[10:00:02]).to be_timed :after, ~T[10:00:01]
        it do: expect(~T[10:00:02]).to be_timed :after_or_at, ~T[10:00:01]
        it do: expect(~T[10:00:01]).to be_timed :after_or_at, ~T[10:00:01]
        it do: expect(~T[10:00:01]).to be_timed :before, ~T[10:00:02]
        it do: expect(~T[10:00:01]).to be_timed :before_or_at, ~T[10:00:02]
        it do: expect(~T[10:00:02]).to be_timed :before_or_at, ~T[10:00:02]
        it do: expect(~T[10:00:01]).to be_timed :not_at, ~T[10:00:02]

        it do: expect(~T[10:00:01]).to_not be_timed :not_at, ~T[10:00:01]
      end

      context "for NaiveDateTime subject" do
        it do: expect(~N[2016-01-01 10:00:02]).to be_timed :after, ~T[10:00:01]
        it do: expect(~N[2016-01-01 10:00:02]).to be_timed :after_or_at, ~T[10:00:01]
        it do: expect(~N[2016-01-01 10:00:01]).to be_timed :after_or_at, ~T[10:00:01]
        it do: expect(~N[2016-01-01 10:00:01]).to be_timed :before, ~T[10:00:02]
        it do: expect(~N[2016-01-01 10:00:01]).to be_timed :before_or_at, ~T[10:00:02]
        it do: expect(~N[2016-01-01 10:00:02]).to be_timed :before_or_at, ~T[10:00:02]
        it do: expect(~N[2016-01-01 10:00:01]).to be_timed :not_at, ~T[10:00:02]
      end

      context "for DateTime subject" do
        it do: expect(DateTime.from_naive!(~N[2016-01-01 10:00:02], "Etc/UTC")).to be_timed :after, ~T[10:00:01]
        it do: expect(DateTime.from_naive!(~N[2016-01-01 10:00:02], "Etc/UTC")).to be_timed :after_or_at, ~T[10:00:01]
        it do: expect(DateTime.from_naive!(~N[2016-01-01 10:00:01], "Etc/UTC")).to be_timed :after_or_at, ~T[10:00:01]
        it do: expect(DateTime.from_naive!(~N[2016-01-01 10:00:01], "Etc/UTC")).to be_timed :before, ~T[10:00:02]
        it do: expect(DateTime.from_naive!(~N[2016-01-01 10:00:01], "Etc/UTC")).to be_timed :before_or_at, ~T[10:00:02]
        it do: expect(DateTime.from_naive!(~N[2016-01-01 10:00:02], "Etc/UTC")).to be_timed :before_or_at, ~T[10:00:02]
        it do: expect(DateTime.from_naive!(~N[2016-01-01 10:00:01], "Etc/UTC")).to be_timed :not_at, ~T[10:00:02]
      end
    end

    context "Errors" do
      it do: expect(~T[10:00:02]).to be_timed :after, ~T[10:00:03]
      it do: expect(~T[10:00:02]).to be_timed :at, 1.0
      it do: expect(1).to be_dated :at, ~T[10:00:02]
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples, true)    
    {:ok,
      success: Enum.slice(examples, 0, 22),
      errors: Enum.slice(examples, 22, 3)}
  end

  test "Success", context do
    Enum.each(context[:success], &(assert(&1.status == :success)))
  end

  test "Errors", context do
    Enum.each(context[:errors], &(assert(&1.status == :failure)))
  end
end
