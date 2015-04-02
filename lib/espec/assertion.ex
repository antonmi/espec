defmodule ESpec.Assertion do

	use Behaviour
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
