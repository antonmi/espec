defmodule ESpec.Assertions.Calendar.Between do
  defmacro match(module) do
    quote do
      defp match(subject, [l, r]) do
        to_l = unquote(module).compare(subject, l) in [:gt, :eq]
        to_r = unquote(module).compare(subject, r) in [:lt, :eq]
        result = to_l and to_r
        {result, result}
      end
    end
  end
end