defmodule ChangeSpec do
  use ESpec

  def add(value), do: Agent.update(:some_spec_agent, &MapSet.put(&1, value))
  def count, do: length(Agent.get(:some_spec_agent, & &1) |> MapSet.to_list())

  before do: Agent.start_link(fn -> MapSet.new() end, name: :some_spec_agent)
  finally do: Agent.stop(:some_spec_agent)

  let :f1, do: fn -> ChangeSpec.add(:value) end
  let :f2, do: &ChangeSpec.count/0
  let :f3, do: fn -> :nothing end

  context "Success" do
    it "checks success with `to`" do
      message = expect(f1()) |> to(change(f2()))
      expect(message) |> to(end_with "changes the value of `&ChangeSpec.count/0`.")
    end

    it "checks success with `to`" do
      message = expect(f1()) |> to(change(f2(), 1))
      expect(message) |> to(end_with "changes the value of `&ChangeSpec.count/0` to `1`.")
    end

    it "checks success with `to`" do
      message = expect(f1()) |> to(change(f2(), 0, 1))

      expect(message)
      |> to(end_with "changes the value of `&ChangeSpec.count/0` from `0` to `1`.")
    end

    it "checks success with `by`" do
      message = expect(f1()) |> to(change(f2(), by: 1))
      expect(message) |> to(end_with "changes the value of `&ChangeSpec.count/0` by `1`.")
    end
  end

  context "Error" do
    it "checks error with `to` for change" do
      try do
        expect(f1()) |> to(change(f3()))
      rescue
        error in [ESpec.AssertionError] ->
          expect(error.message) |> to(end_with "but it didn't change.")
      end
    end

    it "checks error with `not_to` for change" do
      try do
        expect(f1()) |> not_to(change(f2()))
      rescue
        error in [ESpec.AssertionError] ->
          expect(error.message) |> to(end_with "but it changed.")
      end
    end

    it "checks error with `to` for change_to" do
      try do
        expect(f1()) |> to(change(f2(), 2))
      rescue
        error in [ESpec.AssertionError] ->
          expect(error.message)
          |> to(
            end_with "to change the value of `&ChangeSpec.count/0` to `2`, but was changed to `1`"
          )
      end
    end

    it "checks error with `to` for change_to" do
      try do
        expect(f3()) |> to(change(f2(), 2))
      rescue
        error in [ESpec.AssertionError] ->
          expect(error.message)
          |> to(
            end_with "to change the value of `&ChangeSpec.count/0` to `2`, but was not changed"
          )
      end
    end

    it "checks error with `to` for change_to" do
      try do
        expect(f3()) |> to(change(f2(), 0))
      rescue
        error in [ESpec.AssertionError] ->
          expect(error.message)
          |> to(
            end_with "to change the value of `&ChangeSpec.count/0` to `0`, but the initial value is `0`"
          )
      end
    end

    it "checks error with `to` for change_from_to" do
      try do
        expect(f1()) |> to(change(f2(), 0, 2))
      rescue
        error in [ESpec.AssertionError] ->
          expect(error.message)
          |> to(
            end_with "to change the value of `&ChangeSpec.count/0` from `0` to `2`, but the value is `1`."
          )
      end
    end

    it "checks error with `to` for change_from_to" do
      try do
        expect(f1()) |> to(change(f2(), 1, 2))
      rescue
        error in [ESpec.AssertionError] ->
          expect(error.message)
          |> to(
            end_with "to change the value of `&ChangeSpec.count/0` from `1` to `2`, but the initial value is `0`."
          )
      end
    end

    it "checks error with `to` for change_from_to" do
      try do
        expect(f3()) |> to(change(f2(), 0, 2))
      rescue
        error in [ESpec.AssertionError] ->
          expect(error.message)
          |> to(
            end_with "to change the value of `&ChangeSpec.count/0` from `0` to `2`, but the value is `0`."
          )
      end
    end

    it "checks error with `by` for change_by" do
      try do
        expect(f1()) |> to(change(f2(), by: 2))
      rescue
        error in [ESpec.AssertionError] ->
          expect(error.message)
          |> to(
            end_with "to change the value of `&ChangeSpec.count/0` by `2`, but was changed by `1`"
          )
      end
    end

    it "checks error with `by` for change_by" do
      try do
        expect(f3()) |> to(change(f2(), by: 2))
      rescue
        error in [ESpec.AssertionError] ->
          expect(error.message)
          |> to(
            end_with "to change the value of `&ChangeSpec.count/0` by `2`, but was not changed"
          )
      end
    end
  end
end
