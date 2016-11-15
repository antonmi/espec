defmodule ESpec.BeforeAndAfterAll do
  @moduledoc "Defines `before_all` and `after_all` macros."

  @doc "Defines `before_all_function` which is run before all the specs in the module."
  defmacro before_all(do: block) do
    quote do
      def before_all_function do
        unquote(block)
      end
    end
  end

  @doc "Defines `after_all_function` which is run after all the specs in the module."
  defmacro after_all(do: block) do
    quote do
      def after_all_function do
        unquote(block)
      end
    end
  end
end
