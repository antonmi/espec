defmodule ESpec.Assertions.EnumString.Have do
  @moduledoc """
  Defines 'have' assertion.

  it do: expect(enum).to have(value)

  it do: expect(string).to have(value)
  """
  use ESpec.Assertions.Interface

  defp match(enum, [{_key, _value} = tuple]) do
    match(enum, tuple)
  end

  defp match(%{} = map, {key, value}) do
    result = Map.get(map, key) == value
    {result, result}
  end

  defp match(enum, value) when is_binary(enum) do
    result = String.contains?(enum, value)
    {result, result}
  end

  defp match(enum, value) do
    result = Enum.member?(enum, value)
    {result, result}
  end

  defp success_message(enum, value, _result, positive) do
    to_have = if positive, do: "has", else: "doesn't have"
    value = build_success_value_string(value)

    "`#{inspect(enum)}` #{to_have} #{value}."
  end

  defp build_success_value_string([{_, _} = tuple]) do
    build_success_value_string(tuple)
  end

  defp build_success_value_string({key, value}) do
    "`#{inspect(value)}` for key `#{inspect(key)}`"
  end

  defp build_success_value_string(value) do
    "`#{inspect(value)}`"
  end

  defp error_message(enum, value, result, positive) do
    build_error_message(enum, value, result, positive)
  end

  defp build_error_message(enum, [{_, _} = tuple], result, positive) do
    build_error_message(enum, tuple, result, positive)
  end

  defp build_error_message(enum, {key, value}, result, positive) do
    m =
      "Expected `#{inspect(enum)}` #{to(positive)} have `#{inspect(value)}` for key `#{inspect(key)}`, but it #{has(result)}."

    if positive do
      actual = get_value(enum, key)

      {m, %{diff_fn: fn -> ESpec.Diff.diff(actual, value) end}}
    else
      m
    end
  end

  defp build_error_message(enum, value, result, positive) do
    "Expected `#{inspect(enum)}` #{to(positive)} have `#{inspect(value)}`, but it #{has(result)}."
  end

  defp get_value(list, key) when is_list(list) do
    if Keyword.keyword?(list) do
      get_value_from_keyword(list, key)
    else
      nil
    end
  end

  defp get_value(%{} = map, key) do
    Map.get(map, key)
  end

  defp get_value(_, _) do
    nil
  end

  defp get_value_from_keyword(list, key) do
    list
    |> Keyword.get_values(key)
    |> Enum.map_join(" and ", &inspect/1)
  end

  defp to(true), do: "to"
  defp to(false), do: "not to"

  defp has(true), do: "has"
  defp has(false), do: "has not"
end
