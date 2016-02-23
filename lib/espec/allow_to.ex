defmodule ESpec.AllowTo do
  @moduledoc """
  Defines `to/2` function which makes the mock.
  """

  alias ESpec.Mock

  @doc "Makes specific mock with ESpec.Mock.expect/3."
  def to(mock, {__MODULE__, module}) do
    case mock do
      {:accept, name, function} when is_atom(name) -> Mock.expect(module, name, function, [])
      {:accept, name, function, meck_options} when is_atom(name) and is_list(meck_options) ->
        Mock.expect(module, name, function, meck_options)
      {:accept, list} when is_list(list) -> mock_list(module, list)
      {:accept, list, meck_options} when is_list(list) and is_list(meck_options) -> mock_list(module, list, meck_options)
      {:accept, name} when is_atom(name) ->
        Mock.expect(module, name, fn -> nil end, [])
        Mock.expect(module, name, fn(_) -> nil end, [])
    end
  end

  defp mock_list(module, list, meck_options \\ []) do
    if Keyword.keyword?(list) do
      Enum.each(list, fn({name, function}) ->
        Mock.expect(module, name, function, meck_options)
      end)
    else
      Enum.each(list, &Mock.expect(module, &1, fn -> nil end, meck_options))
      Enum.each(list, &Mock.expect(module, &1, fn(_) -> nil end, meck_options))
    end
  end
end
