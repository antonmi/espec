defmodule ESpec.Assertions.Enum.HaveMinBySpec do
  use ESpec, async: true

  let :range, do: 1..3
  let :func, do: fn el -> 10 / el end

  context "Success" do
    it "checks success with `to`" do
      message = expect(range()) |> to(have_min_by(func(), 3))
      expect(message) |> to(start_with "The minimum value of `1..3` using")
      expect(message) |> to(end_with "is `3`.")
    end

    it "checks success with `not_to`" do
      message = expect(range()) |> to_not(have_min_by(func(), 1))
      expect(message) |> to(start_with "The minimum value of `1..3` using")
      expect(message) |> to(end_with "is not `1`.")
    end
  end

  context "Error" do
    it "checks error with `to`" do
      try do
        expect(range()) |> to(have_min_by(func(), 1))
      rescue
        error in [ESpec.AssertionError] ->
          expect(error.message) |> to(start_with "Expected the minimum value of `1..3` using")
          expect(error.message) |> to(end_with "to be `1` but the minimum is `3`.")
      end
    end

    it "checks error with `not_to`" do
      try do
        expect(range()) |> to_not(have_min_by(func(), 3))
      rescue
        error in [ESpec.AssertionError] ->
          expect(error.message) |> to(start_with "Expected the minimum value of `1..3` using")
          expect(error.message) |> to(end_with "not to be `3` but the minimum is `3`.")
      end
    end
  end
end
