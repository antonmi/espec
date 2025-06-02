defmodule ESpec.Assertions.BeCloseTo do
  @moduledoc """
  Defines 'be_close_to' assertion.

  it do: expect(2).to be_close_to(1, 3)
  """
  use ESpec.Assertions.Interface

  alias ESpec.DatesTimes.Comparator

  defp match(subject, [value, {granularity, delta}] = _data) do
    actual_delta =
      subject
      |> Comparator.diff(value, granularity)
      |> abs()

    result =
      actual_delta
      |> Kernel.<=(delta)

    {result, {granularity, actual_delta}}
  end

  defp match(subject, data) do
    [value, delta] = data
    result = abs(subject - value) <= delta
    {result, result}
  end

  defp success_message(subject, [value, delta], _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect(subject)}` #{to} close to `#{inspect(value)}` with delta `#{inspect(delta)}`."
  end

  defp error_message(subject, [value, delta], {granularity, actual_delta} = _result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if actual_delta == delta, do: "it is", else: "it isn't"

    {
      "Expected `#{inspect(subject)}` #{to} be close to `#{inspect(value)}` with delta `#{inspect(delta)}`, but #{but}. The actual delta is {:#{granularity}, #{actual_delta}}.",
      nil
    }
  end

  defp error_message(subject, [value, delta], result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if result, do: "it is", else: "it isn't"

    {
      "Expected `#{inspect(subject)}` #{to} be close to `#{inspect(value)}` with delta `#{inspect(delta)}`, but #{but}.",
      nil
    }
  end
end
