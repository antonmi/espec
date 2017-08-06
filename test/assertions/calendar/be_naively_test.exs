defmodule Calendar.BeNaivelyTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    context "Success" do
      context "for NaiveDateTime subject" do
        it do: expect(~N[2017-01-02 10:00:00]).to be_naively :after, ~N[2017-01-01 10:00:00]
        it do: expect(~N[2017-01-02 10:00:00]).to be_naively :after_or_at, ~N[2017-01-01 10:00:00]
        it do: expect(~N[2017-01-01 10:00:00]).to be_naively :after_or_at, ~N[2017-01-01 10:00:00]
        it do: expect(~N[2017-01-01 10:00:00]).to be_naively :before, ~N[2017-01-02 10:00:00]
        it do: expect(~N[2017-01-01 10:00:00]).to be_naively :before_or_at, ~N[2017-01-02 10:00:00]
        it do: expect(~N[2017-01-02 10:00:00]).to be_naively :before_or_at, ~N[2017-01-02 10:00:00]
        it do: expect(~N[2017-01-01 10:00:00]).to be_naively :not_at, ~N[2017-01-02 10:00:00]
        it do: expect(~N[2017-01-01 10:00:00]).to be_naively :at, ~N[2017-01-01 10:00:00]

        it do: expect(~N[2017-01-01 10:00:00]).to_not be_naively :not_at, ~N[2017-01-01 10:00:00]
      end

      context "for DateTime subject" do
        it do: expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to be_naively :after, ~N[2017-01-01 10:00:00]
        it do: expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to be_naively :after_or_at, ~N[2017-01-01 10:00:00]
        it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to be_naively :after_or_at, ~N[2017-01-01 10:00:00]
        it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to be_naively :before, ~N[2017-01-02 10:00:00]
        it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to be_naively :before_or_at, ~N[2017-01-02 10:00:00]
        it do: expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to be_naively :before_or_at, ~N[2017-01-02 10:00:00]
        it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to be_naively :not_at, ~N[2017-01-02 10:00:00]
        it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to be_naively :at, ~N[2017-01-01 10:00:00]
      end
    end

    context "Errors" do
      it do: expect(~N[2017-01-02 10:00:00]).to be_naively :after, ~N[2017-01-03 10:00:00]
      it do: expect(~N[2017-04-02 10:00:00]).to be_naively :at, 1.0
      it do: expect(1).to be_naively :at, ~N[2017-04-02 10:00:00]
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples, true)    
    {:ok,
      success: Enum.slice(examples, 0, 17),
      errors: Enum.slice(examples, 17, 3)}
  end

  test "Success", context do
    Enum.each(context[:success], &(assert(&1.status == :success)))
  end

  test "Errors", context do
    Enum.each(context[:errors], &(assert(&1.status == :failure)))
  end
end
