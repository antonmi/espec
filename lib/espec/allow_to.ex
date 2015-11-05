defmodule ESpec.AllowTo do
  @moduledoc """
  Defines `to/2` function which makes the mock.
  """

  @doc "Makes specific mock with ESpec.Mock.expect/3."
  def to(mock, {ESpec.AllowTo, module}) do
    case mock do
      {:accept, name, function} when is_atom(name) -> ESpec.Mock.expect(module, name, function, [])
      {:accept, name, function, meck_options} when is_atom(name) and is_list(meck_options) ->
        ESpec.Mock.expect(module, name, function, meck_options)
      {:accept, list} when is_list(list) -> mock_list(module, list)
      {:accept, list, meck_options} when is_list(list) and is_list(meck_options) -> mock_list(module, list, meck_options)
      {:accept, name} when is_atom(name) ->
        ESpec.Mock.expect(module, name, fn -> end, [])
        ESpec.Mock.expect(module, name, fn(_) -> end, [])
    end
  end

  defp mock_list(module, list, meck_options \\ []) do
    if Keyword.keyword?(list) do
      Enum.each(list, fn({name, function}) ->
        ESpec.Mock.expect(module, name, function, meck_options)
      end)
    else
      Enum.each(list, &ESpec.Mock.expect(module, &1, fn -> end, meck_options))
      Enum.each(list, &ESpec.Mock.expect(module, &1, fn(_) -> end, meck_options))
    end
  end
end
