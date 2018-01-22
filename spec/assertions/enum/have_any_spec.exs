defmodule ESpec.Assertions.Enum.HaveAnySpec do
  use ESpec, async: true

  let :range, do: 1..3

  let :positive, do: fn el -> el == 2 end
  let :negative, do: fn el -> el < 0 end

  context "Success" do
    it "checks success with `to`" do
      message = expect(range()).to(have_any(positive()))
      expect(message) |> to(end_with "returns `true` for at least one element in `1..3`.")
    end

    it "checks success with `not_to`" do
      message = expect(range()).to_not(have_any(negative()))
      expect(message) |> to(end_with "doesn't return `true` for any element in `1..3`.")
    end
  end

  context "Error" do
    it "checks error with `to`" do
      try do
        expect(range()).to(have_any(negative()))
      rescue
        error in [ESpec.AssertionError] ->
          expect(error.message)
          |> to(
            end_with "to return `true` for at least one element in `1..3` but it returns `false` for all."
          )
      end
    end

    it "checks error with `not_to`" do
      try do
        expect(range()).to_not(have_any(positive()))
      rescue
        error in [ESpec.AssertionError] ->
          expect(error.message)
          |> to(
            end_with "not to return `true` for at least one element in `1..3` but it returns `true` for all."
          )
      end
    end
  end
end
