defmodule ESpec.Assertions.Enum.HaveCountBySpec do
  use ESpec, async: true

  let :range, do: 1..3
  let :func, do: fn el -> el > 1 end

  context "Success" do
    it "checks success with `to`" do
      message = expect(range()) |> to(have_count_by(func(), 2))
      expect(message) |> to(start_with "`1..3` count_by")
      expect(message) |> to(end_with "is `2`.")
    end

    it "checks success with `not_to`" do
      message = expect(range()) |> to_not(have_count_by(func(), 3))
      expect(message) |> to(start_with "`1..3` count_by")
      expect(message) |> to(end_with "is not `3`.")
    end
  end

  context "Error" do
    it "checks error with `to`" do
      try do
        expect(range()) |> to(have_count_by(func(), 3))
      rescue
        error in [ESpec.AssertionError] ->
          expect(error.message) |> to(start_with "Expected `1..3` to have count_by")
          expect(error.message) |> to(end_with "be equal to `3` but it has `2` elements.")
      end
    end

    it "checks error with `not_to`" do
      try do
        expect(range()) |> to_not(have_count_by(func(), 2))
      rescue
        error in [ESpec.AssertionError] ->
          expect(error.message) |> to(start_with "Expected `1..3` not to have count_by")
          expect(error.message) |> to(end_with "be equal to `2` but it has `2` elements.")
      end
    end
  end
end
