defmodule ESpec.Assertions.RaiseExceptionSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.RaiseException" do
    let :func1, do: fn -> raise(ArithmeticError) end
    let :func2, do: fn -> 1 + 1 end
    let :func3, do: fn -> List.first(:a) end
    let :func4, do: fn -> raise(ArgumentError) end

    context "Success" do
      it "checks success with `to`" do
        message = expect(func1()) |> to(raise_exception())
        expect(message) |> to(end_with "raises an exception.")
      end

      it "checks success with `to`" do
        message = expect(func1()) |> to(raise_exception(ArithmeticError))
        expect(message) |> to(end_with "raises the `Elixir.ArithmeticError` exception.")
      end

      it "checks success with `to`" do
        message =
          expect(func1()) |> to(
            raise_exception(ArithmeticError, "bad argument in arithmetic expression")
          )

        expect(message)
        |> to(
          end_with "raises the `Elixir.ArithmeticError` exception with the message `bad argument in arithmetic expression`."
        )
      end

      it "checks success with `not_to`" do
        message = expect(func2()) |> to_not(raise_exception())
        expect(message) |> to(end_with "doesn't raise an exception.")
      end

      it "checks success with `not_to`" do
        message = expect(func2()) |> to_not(raise_exception(ArithmeticError))
        expect(message) |> to(end_with "doesn't raise the `Elixir.ArithmeticError` exception.")
      end

      it "checks success with `not_to`" do
        message =
          expect(func2()) |> to_not(
            raise_exception(ArithmeticError, "bad argument in arithmetic expression")
          )

        expect(message)
        |> to(
          end_with "doesn't raise the `Elixir.ArithmeticError` exception with the message `bad argument in arithmetic expression`."
        )
      end

      it "checks success with `not_to`" do
        message = expect(func3()) |> to_not(raise_exception(ArithmeticError))
        expect(message) |> to(end_with "doesn't raise the `Elixir.ArithmeticError` exception.")
      end

      it "checks success with `not_to`" do
        message = expect(func3()) |> to_not(raise_exception(FunctionClauseError, "no such message"))

        expect(message)
        |> to(
          end_with "doesn't raise the `Elixir.FunctionClauseError` exception with the message `no such message`."
        )
      end
    end

    context "Errors" do
      it "checks error with `to`" do
        try do
          expect(func2()) |> to(raise_exception())
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message) |> to(end_with "to raise an exception, but nothing was raised.")
        end
      end

      it "checks error with `to`" do
        try do
          expect(func2()) |> to(raise_exception(ArithmeticError))
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message)
            |> to(
              end_with "to raise the `Elixir.ArithmeticError` exception, but nothing was raised."
            )
        end
      end

      it "checks error with `to`" do
        try do
          expect(func4()) |> to(raise_exception(ArithmeticError))
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message)
            |> to(
              end_with "to raise the `Elixir.ArithmeticError` exception, but `Elixir.ArgumentError` was raised instead."
            )
        end
      end

      it "checks error with `to`" do
        try do
          expect(func2()) |> to(
            raise_exception(ArithmeticError, "bad argument in arithmetic expression")
          )
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message)
            |> to(
              end_with "to raise the `Elixir.ArithmeticError` exception with the message `bad argument in arithmetic expression`, but nothing was raised."
            )
        end
      end

      it "checks error with `to`" do
        try do
          expect(func4()) |> to(
            raise_exception(ArithmeticError, "bad argument in arithmetic expression")
          )
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message)
            |> to(
              end_with "to raise the `Elixir.ArithmeticError` exception with the message `bad argument in arithmetic expression`, but the `Elixir.ArgumentError` exception was raised with the message `argument error`."
            )
        end
      end

      it "checks error with `not_to`" do
        try do
          expect(func1()) |> not_to(raise_exception())
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message)
            |> to(end_with "not to raise an exception, but an exception was raised.")
        end
      end

      it "checks error with `not_to`" do
        try do
          expect(func1()) |> not_to(raise_exception(ArithmeticError))
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message)
            |> to(
              end_with "not to raise the `Elixir.ArithmeticError` exception, but the `Elixir.ArithmeticError` exception was raised."
            )
        end
      end

      it "checks error with `not_to`" do
        try do
          expect(func1()) |> not_to(
            raise_exception(ArithmeticError, "bad argument in arithmetic expression")
          )
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message)
            |> to(
              end_with "not to raise the `Elixir.ArithmeticError` exception with the message `bad argument in arithmetic expression`, but the `Elixir.ArithmeticError` exception was raised with the message `bad argument in arithmetic expression`."
            )
        end
      end

      it "checks error with `to`" do
        try do
          expect(func1()) |> to(
            raise_exception(AnotherError, "bad argument in arithmetic expression")
          )
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message)
            |> to(
              end_with "to raise the `Elixir.AnotherError` exception with the message `bad argument in arithmetic expression`, but the `Elixir.ArithmeticError` exception was raised with the message `bad argument in arithmetic expression`."
            )
        end
      end

      it "checks error with `to`" do
        try do
          expect(func1()) |> to(raise_exception(ArithmeticError, "another message"))
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message)
            |> to(
              end_with "to raise the `Elixir.ArithmeticError` exception with the message `another message`, but the `Elixir.ArithmeticError` exception was raised with the message `bad argument in arithmetic expression`."
            )
        end
      end

      it "checks error with `not_to`" do
        try do
          expect(func3()) |> to_not(raise_exception(FunctionClauseError))
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message)
            |> to(
              end_with "not to raise the `Elixir.FunctionClauseError` exception, but the `Elixir.FunctionClauseError` exception was raised."
            )
        end
      end

      it "checks error with `not_to`" do
        try do
          expect(func3()) |> to_not(
            raise_exception(FunctionClauseError, "no function clause matching in List.first/1")
          )
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message)
            |> to(
              end_with "not to raise the `Elixir.FunctionClauseError` exception with the message `no function clause matching in List.first/1`, but the `Elixir.FunctionClauseError` exception was raised with the message `no function clause matching in List.first/1`."
            )
        end
      end
    end
  end
end
