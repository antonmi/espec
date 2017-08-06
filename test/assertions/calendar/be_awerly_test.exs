defmodule Calendar.BeAwarelyTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    context "Success" do
      context "for DateTime subject" do
        it do: expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to be_awarely :after, DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")
        it do: expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to be_awarely :after_or_at, DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")
        it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to be_awarely :after_or_at, DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")
        it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to be_awarely :before, DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")
        it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to be_awarely :before_or_at, DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")
        it do: expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to be_awarely :before_or_at, DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")
        it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to be_awarely :not_at, DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")
        it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to be_awarely :at, DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")

        it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to_not be_awarely :not_at, DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")
      end
    end

    context "Errors" do
      it do: expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to be_awarely :after, DateTime.from_naive!(~N[2017-01-03 10:00:00], "Etc/UTC")
      it do: expect(DateTime.from_naive!(~N[2017-04-02 10:00:00], "Etc/UTC")).to be_awarely :at, 1.0
      it do: expect(1).to be_awarely :at, DateTime.from_naive!(~N[2017-04-02 10:00:00], "Etc/UTC")
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples, true)    
    {:ok,
      success: Enum.slice(examples, 0, 9),
      errors: Enum.slice(examples, 9, 3)}
  end

  test "Success", context do
    Enum.each(context[:success], &(assert(&1.status == :success)))
  end

  test "Errors", context do
    Enum.each(context[:errors], &(assert(&1.status == :failure)))
  end
end
