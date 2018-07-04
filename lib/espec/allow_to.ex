defmodule ESpec.AllowTo do
  @moduledoc """
  Defines `to/2` function which makes the mock.
  """

  alias ESpec.Mock

  @doc "Makes specific mock with ESpec.Mock.expect/3."
  def to({:accept, name, function}, {__MODULE__, module}) when is_atom(name) and is_atom(module) do
    Mock.expect(module, name, function, [])
  end

  def to({:accept, name, function}, {__MODULE__, {__MODULE__, module}}) when is_atom(name) and is_atom(module) do
    Mock.expect(module, name, function, [])
  end

  def to({:accept, name, function, meck_options}, {__MODULE__, module})
      when is_atom(name) and is_atom(module) and is_list(meck_options) do
    Mock.expect(module, name, function, meck_options)
  end

  def to({:accept, name, function, meck_options}, {__MODULE__, {__MODULE__, module}})
      when is_atom(name) and is_atom(module) and is_list(meck_options) do
    Mock.expect(module, name, function, meck_options)
  end

  def to({:accept, list}, {__MODULE__, module}) when is_list(list) and is_atom(module) do
    mock_list(module, list)
  end

  def to({:accept, list}, {__MODULE__, {__MODULE__, module}}) when is_list(list) and is_atom(module) do
    mock_list(module, list)
  end

  def to({:accept, list, meck_options}, {__MODULE__, module})
      when is_list(list) and is_list(meck_options) and is_atom(module) do
    mock_list(module, list, meck_options)
  end

  def to({:accept, list, meck_options}, {__MODULE__, {__MODULE__, module}})
      when is_list(list) and is_list(meck_options) and is_atom(module) do
    mock_list(module, list, meck_options)
  end

  def to({:accept, name}, {__MODULE__, module}) when is_atom(name) and is_atom(module) do
    Mock.expect(module, name, fn -> nil end, [])
    Mock.expect(module, name, fn _ -> nil end, [])
  end

  def to({:accept, name}, {__MODULE__, {__MODULE__, module}}) when is_atom(name) and is_atom(module) do
    Mock.expect(module, name, fn -> nil end, [])
    Mock.expect(module, name, fn _ -> nil end, [])
  end

  defp mock_list(module, list, meck_options \\ []) do
    if Keyword.keyword?(list) do
      Enum.each(list, fn {name, function} ->
        Mock.expect(module, name, function, meck_options)
      end)
    else
      Enum.each(list, &Mock.expect(module, &1, fn -> nil end, meck_options))
      Enum.each(list, &Mock.expect(module, &1, fn _ -> nil end, meck_options))
    end
  end
end
