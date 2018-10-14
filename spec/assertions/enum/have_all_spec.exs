defmodule ESpec.Assertions.Enum.HaveAllSpec do
  use ESpec, async: true

  let :range, do: 1..3
  let :list, do: [1, 2, 3]
  let :dict, do: %{a: 1, b: 2, c: 3}

  let :positive, do: fn el -> el > 0 end
  let :negative, do: fn el -> el < 0 end

  context "Success" do
    it "checks success with `to`" do
      message = expect(range()) |> to(have_all(positive()))
      expect(message) |> to(end_with "returns `true` for all elements in `1..3`.")
    end

    it "checks success with `to`" do
      message = expect(list()) |> to(have_all(positive()))
      expect(message) |> to(end_with "returns `true` for all elements in `[1, 2, 3]`.")
    end

    it "checks success with `to`" do
      message = expect(dict()) |> to(have_all(positive()))
      expect(message) |> to(end_with "returns `true` for all elements in `%{a: 1, b: 2, c: 3}`.")
    end

    it "checks success with `not_to`" do
      message = expect(range()) |> to_not(have_all(negative()))
      expect(message) |> to(end_with "doesn't return `true` for all elements in `1..3`.")
    end
  end

  context "Error" do
    it "checks error with `to`" do
      try do
        expect(range()) |> to(have_all(negative()))
      rescue
        error in [ESpec.AssertionError] ->
          expect(error.message)
          |> to(
            end_with "to return `true` for all elements in `1..3`, but it returns `false` for some."
          )
      end
    end

    it "checks error with `not_to`" do
      try do
        expect(range()) |> to_not(have_all(positive()))
      rescue
        error in [ESpec.AssertionError] ->
          expect(error.message)
          |> to(
            end_with "not to return `true` for all elements in `1..3`, but it returns `true` for all."
          )
      end
    end
  end
end
