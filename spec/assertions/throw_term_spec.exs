defmodule ESpec.Assertions.ThrowTermSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.RaiseException" do
    let :func1, do: fn -> throw(:some_term) end
    let :func2, do: fn -> 1 + 1 end
    let :func3, do: fn -> throw({:throw, :some, :tuple}) end

    context "Success" do
      it "checks success with `to`" do
        message = expect(func1()).to(throw_term())
        expect(message) |> to(end_with "throws a term.")
      end

      it "checks success with `to`" do
        message = expect(func1()).to(throw_term(:some_term))
        expect(message) |> to(end_with "throws the `:some_term` term.")
      end

      it "checks success with `to`" do
        message = expect(func3()).to(throw_term({:throw, :some, :tuple}))
        expect(message) |> to(end_with "throws the `{:throw, :some, :tuple}` term.")
      end

      it "checks success with `not_to`" do
        message = expect(func1()).not_to(throw_term(:another_term))
        expect(message) |> to(end_with "doesn't throw the `:another_term` term.")
      end
    end

    context "Errors" do
      it "checks error with `to`" do
        try do
          expect(func2()).to(throw_term())
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message) |> to(end_with "to throw term, but nothing was thrown.")
        end
      end

      it "checks error with `not_to`" do
        try do
          expect(func1()).to_not(throw_term())
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message)
            |> to(end_with "not to throw term, but `:some_term` was thrown.")
        end
      end

      it "checks error with `to`" do
        try do
          expect(func2()).to(throw_term(:some_term))
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message) |> to(end_with "to throw :some_term, but nothing was thrown.")
        end
      end

      it "checks error with `to`" do
        try do
          expect(func1()).to(throw_term(:another_term))
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message)
            |> to(end_with "to throw :another_term, but the `:some_term` was thrown.")
        end
      end

      it "checks error with `not_to`" do
        try do
          expect(func1()).not_to(throw_term(:some_term))
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message)
            |> to(end_with "not to throw :some_term, but the `:some_term` was thrown.")
        end
      end

      it "checks error with `not_to`" do
        try do
          expect(func3()).not_to(throw_term({:throw, :some, :tuple}))
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message)
            |> to(
              end_with "not to throw {:throw, :some, :tuple}, but the `{:throw, :some, :tuple}` was thrown."
            )
        end
      end
    end
  end
end
