defmodule ESpec.Assertions.Interface do
  @moduledoc """
  Defines the assertion interface.
  There are 3 function should be defined in the 'assertion' module:
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

      defp raise_error(subject, data, result, positive) do
        raise ESpec.AssertionError, subject: subject, data: data, result: result,
        asserion: __MODULE__, message: error_message(subject, data, result, positive)
      end
    end
  end
end
