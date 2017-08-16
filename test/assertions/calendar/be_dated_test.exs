defmodule Calendar.BeDatedTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    context "Success" do
      context "for Date subject" do
        it do: expect(~D[2017-01-02]).to be_dated :after, ~D[2017-01-01]
        it do: expect(~D[2017-01-02]).to be_dated :after_or_at, ~D[2017-01-01]
        it do: expect(~D[2017-01-01]).to be_dated :after_or_at, ~D[2017-01-01]
        it do: expect(~D[2017-01-01]).to be_dated :before, ~D[2017-01-02]
        it do: expect(~D[2017-01-01]).to be_dated :before_or_at, ~D[2017-01-02]
        it do: expect(~D[2017-01-02]).to be_dated :before_or_at, ~D[2017-01-02]
        it do: expect(~D[2017-01-01]).to be_dated :not_at, ~D[2017-01-02]
        it do: expect(~D[2017-01-01]).to be_dated :at, ~D[2017-01-01]

        it do: expect(~D[2017-01-01]).to_not be_dated :not_at, ~D[2017-01-01]
      end

      context "for NaiveDateTime subject" do
        it do: expect(~N[2017-01-02 10:00:00]).to be_dated :after, ~D[2017-01-01]
        it do: expect(~N[2017-01-02 10:00:00]).to be_dated :after_or_at, ~D[2017-01-01]
        it do: expect(~N[2017-01-01 10:00:00]).to be_dated :after_or_at, ~D[2017-01-01]
        it do: expect(~N[2017-01-01 10:00:00]).to be_dated :before, ~D[2017-01-02]
        it do: expect(~N[2017-01-01 10:00:00]).to be_dated :before_or_at, ~D[2017-01-02]
        it do: expect(~N[2017-01-02 10:00:00]).to be_dated :before_or_at, ~D[2017-01-02]
        it do: expect(~N[2017-01-01 10:00:00]).to be_dated :not_at, ~D[2017-01-02]
        it do: expect(~N[2017-01-01 10:00:00]).to be_dated :at, ~D[2017-01-01]
      end

      context "for DateTime subject" do
        it do: expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to be_dated :after, ~D[2017-01-01]
        it do: expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to be_dated :after_or_at, ~D[2017-01-01]
        it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to be_dated :after_or_at, ~D[2017-01-01]
        it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to be_dated :before, ~D[2017-01-02]
        it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to be_dated :before_or_at, ~D[2017-01-02]
        it do: expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to be_dated :before_or_at, ~D[2017-01-02]
        it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to be_dated :not_at, ~D[2017-01-02]
        it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to be_dated :at, ~D[2017-01-01]
      end
    end

    context "Errors" do
      it do: expect(~D[2017-01-02]).to be_dated :after, ~D[2017-01-03]
      it do: expect(~D[2017-04-02]).to be_dated :at, 1.0
      it do: expect(1).to be_dated :at, ~D[2017-04-02]
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples, true)    
    {:ok,
      success: Enum.slice(examples, 0, 25),
      errors: Enum.slice(examples, 25, 3)}
  end

  test "Success", context do
    Enum.each(context[:success], &(assert(&1.status == :success)))
  end

  test "Errors", context do
    Enum.each(context[:errors], &(assert(&1.status == :failure)))
  end
end
