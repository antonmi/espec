defmodule ESpec.Assertions.Be do
  @moduledoc """
  Defines 'be' assertion.

  it do: expect(2).to be :>, 1
  """
  use ESpec.Assertions.Interface

  alias ESpec.DatesTimes.Comparator

  defp match(subject, [op, val, [{granularity, delta}]]) do
    actual_delta =
      subject
      |> Comparator.diff(val, granularity)
      |> abs()

    result = apply(Kernel, op, [subject, val]) && apply(Kernel, op, [actual_delta, delta])
    {result, {granularity, actual_delta}}
  end

  defp match(subject, [op, val, {granularity, delta}]) do
    actual_delta =
      subject
      |> Comparator.diff(val, granularity)
      |> abs()

    result = apply(Kernel, op, [subject, val]) && apply(Kernel, op, [actual_delta, delta])
    {result, {granularity, actual_delta}}
  end

  defp match(%Date{} = subject, [op, %Date{} = val]), do: match_date_times(subject, [op, val])
  defp match(%Time{} = subject, [op, %Time{} = val]), do: match_date_times(subject, [op, val])

  defp match(%DateTime{} = subject, [op, %DateTime{} = val]),
    do: match_date_times(subject, [op, val])

  defp match(%NaiveDateTime{} = subject, [op, %NaiveDateTime{} = val]),
    do: match_date_times(subject, [op, val])

  defp match(subject, [op, val]) do
    result = apply(Kernel, op, [subject, val])
    {result, result}
  end

  defp match_date_times(subject, [op, val]) do
    delta = subject |> Comparator.diff(val, :microsecond)

    result = apply(Kernel, op, [delta, 0])
    {result, result}
  end

  defp success_message(subject, [op, val, [{granularity, delta}]], _result, positive) do
    to = if positive, do: "is true", else: "is false"
    "`#{inspect(subject)} #{op} #{inspect(val)}` #{to} with delta `[#{granularity}: #{delta}]`."
  end

  defp success_message(subject, [op, val, {granularity, delta}], _result, positive) do
    to = if positive, do: "is true", else: "is false"
    "`#{inspect(subject)} #{op} #{inspect(val)}` #{to} with delta `{:#{granularity}, #{delta}}`."
  end

  defp success_message(subject, [op, val], _result, positive) do
    to = if positive, do: "is true", else: "is false"
    "`#{inspect(subject)} #{op} #{inspect(val)}` #{to}."
  end

  defp error_message(
         subject,
         [op, val, [{granularity, delta}]],
         {actual_granularity, actual_delta},
         positive
       ) do
    {
      "Expected `#{inspect(subject)} #{op} #{inspect(val)}` to be `#{positive}` but got `#{!positive}` with delta `[#{granularity}: #{delta}]`. The actual delta is [#{actual_granularity}: #{actual_delta}], with an inclusive boundary.",
      nil
    }
  end

  defp error_message(
         subject,
         [op, val, {granularity, delta}],
         {actual_granularity, actual_delta},
         positive
       ) do
    {
      "Expected `#{inspect(subject)} #{op} #{inspect(val)}` to be `#{positive}` but got `#{!positive}` with delta `{:#{granularity}, #{delta}}`. The actual delta is {:#{actual_granularity}, #{actual_delta}}, with an inclusive boundary.",
      nil
    }
  end

  defp error_message(subject, [op, val], _result, positive) do
    {
      "Expected `#{inspect(subject)} #{op} #{inspect(val)}` to be `#{positive}` but got `#{!positive}`.",
      nil
    }
  end
end
