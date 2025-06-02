defmodule ESpec.Assertions.Interface do
  @moduledoc """
  Defines the assertion interface.
  There are 3 functions that should be defined in the 'assertion' module:
  - `match/2`;
  - `success_message/4`;
  - `error_message/4`.
  """
  defmacro __using__(_opts) do
    quote do
      def assert(subject, data, positive \\ true) do
        case match(subject, data) do
          {false, result} when positive -> raise_error(subject, data, result, positive)
          {true, result} when not positive -> raise_error(subject, data, result, positive)
          {true, result} when positive -> success_message(subject, data, result, positive)
          {false, result} when not positive -> success_message(subject, data, result, positive)
        end
      end

      def assert(subject, data, positive, stacktrace) do
        case match(subject, data) do
          {false, result} when positive ->
            raise_error(subject, data, result, positive, stacktrace)

          {true, result} when not positive ->
            raise_error(subject, data, result, positive, stacktrace)

          {true, result} when positive ->
            success_message(subject, data, result, positive)

          {false, result} when not positive ->
            success_message(subject, data, result, positive)
        end
      end

      defp raise_error(subject, data, result, positive, stacktrace \\ nil) do
        {message, extra} = error_message(subject, data, result, positive)

        raise ESpec.AssertionError,
          subject: subject,
          data: data,
          result: result,
          assertion: __MODULE__,
          message: message,
          extra: extra,
          stacktrace: stacktrace
      end
    end
  end
end
