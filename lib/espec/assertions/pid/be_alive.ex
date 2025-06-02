defmodule ESpec.Assertions.PID.BeAlive do
  @moduledoc """
  Defines 'be_alive' assertion.

  it do: expect(self()).to be_alive
  """
  use ESpec.Assertions.Interface

  defp match(subject, _val) do
    result = Process.alive?(subject)
    {result, result}
  end

  defp success_message(subject, _val, _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect(subject)}` #{to} alive."
  end

  defp error_message(subject, _val, _result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if positive, do: "it isn't", else: "it is"
    {"Expected `#{inspect(subject)}` #{to} be alive but #{but}.", nil}
  end
end
