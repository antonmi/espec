defmodule ESpec.Assertions.Result.BeErrorResult do
  @moduledoc """
  Defines 'be_ok_result' assertion.

  it do: expect({:ok, :result}).to be_ok_result
  """
  use ESpec.Assertions.Interface

  defp match(tuple, _data) do
    case tuple do
      {:error, _} -> {true, nil}
      _ -> {false, nil}
    end
  end

  defp success_message(tuple, _data, _result, positive) do
    to = if positive, do: "is", else: "isn't"
    "`#{inspect tuple}` #{to} a error result."
  end

  defp error_message(tuple, _data, _result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if positive, do: "it is not", else: "it is"
    "Expected `#{inspect tuple}` #{to} be a error result but #{but}."
  end
end
