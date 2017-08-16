defmodule ESpec.Assertions.Calendar.Comparision do
  defmacro match(module) do
    quote do
      defp match(subject, [op, val]) do
        result = case unquote(module).compare(subject, val) do
          :gt -> op in [:after, :after_or_at, :not_at]
          :lt -> op in [:before, :before_or_at, :not_at]
          :eq -> op in [:at, :before_or_at, :after_or_at]
        end
        {result, result}
      end
    end
  end
end