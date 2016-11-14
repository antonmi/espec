defmodule ChangeTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    def add(value), do: Agent.update(:some_spec_agent, &(Set.put(&1, value)))
    def count, do: length(Agent.get(:some_spec_agent, &(&1)) |> Set.to_list)

    before do: Agent.start_link(fn -> MapSet.new end, name: :some_spec_agent)
    finally do: Agent.stop(:some_spec_agent)

    let :f1, do: fn -> ChangeTest.SomeSpec.add(:value) end
    let :f2, do: &ChangeTest.SomeSpec.count/0

    context "Success" do
      it "change", do: expect(f1()).to change(f2())
      it "change_to", do: expect(f1()).to change(f2(), 1)
      it "change_from_to", do: expect(f1()).to change(f2(), 0, 1)
    end

    context "Error" do
      it "change", do: expect(f1()).not_to change(f2())
      it "change_to", do: expect(f1()).to change(f2(), 2)
      it "change_from_to", do: expect(f1()).to change(f2(), 0, 2)
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples, true)
    {:ok,
      success: Enum.slice(examples, 0, 2),
      errors: Enum.slice(examples, 3, 5)}
  end

  test "Success", context do
    Enum.each(context[:success], &(assert(&1.status == :success)))
  end

  test "Errors", context do
    Enum.each(context[:errors], &(assert(&1.status == :failure)))
  end
end
