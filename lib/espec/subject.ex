defmodule ESpec.Subject do

  defmacro subject(do: block) do
    quote do

      def subject do
        unquote(block)
      end

    end
  end

end
