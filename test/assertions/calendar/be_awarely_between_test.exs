defmodule Calendar.BeAwarelyBetweenTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec
    
    context "Success" do
      context "for DateTime subject" do
        it do: expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to be_awarely_between(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC"), DateTime.from_naive!(~N[2017-01-03 10:00:00], "Etc/UTC"))
        it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to be_awarely_between(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC"), DateTime.from_naive!(~N[2017-01-03 10:00:00], "Etc/UTC"))
        it do: expect(DateTime.from_naive!(~N[2017-01-03 10:00:00], "Etc/UTC")).to be_awarely_between(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC"), DateTime.from_naive!(~N[2017-01-03 10:00:00], "Etc/UTC"))
      end
    end

    context "Errors" do
      it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to be_awarely_between(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC"), DateTime.from_naive!(~N[2017-01-03 10:00:00], "Etc/UTC"))
      it do: expect(DateTime.from_naive!(~N[2017-01-04 10:00:00], "Etc/UTC")).to be_awarely_between(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC"), DateTime.from_naive!(~N[2017-01-03 10:00:00], "Etc/UTC"))
      it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to_not be_awarely_between(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC"), DateTime.from_naive!(~N[2017-01-03 10:00:00], "Etc/UTC"))
      it do: expect(DateTime.from_naive!(~N[2017-01-03 10:00:00], "Etc/UTC")).to_not be_awarely_between(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC"), DateTime.from_naive!(~N[2017-01-03 10:00:00], "Etc/UTC"))
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples, true)
    {:ok,
      success: Enum.slice(examples, 0, 3),
      errors: Enum.slice(examples, 3, 4)}
  end

  test "Success", context do
    Enum.each(context[:success], &(assert(&1.status == :success)))
  end

  test "Errors", context do
    Enum.each(context[:errors], &(assert(&1.status == :failure)))
  end
end
