defmodule ESpec.Assertions.AssertReceive do
  @moduledoc """
  Defines 'assert_receive' and 'assert_received' assertions.

  it do: assert_receive :hello
  """
  use ESpec.Assertions.Interface

  @join_sym "\n\t"

  defp match(subject, [pattern, _pins, _mailbox_messages]) do
    case subject do
      {:error, :timeout} -> {false, pattern}
      {pattern, _vars} -> {true, pattern}
    end
  end

  defp success_message(_subject, _val, result, _positive) do
    "Received `#{inspect result}`."
  end

  defp error_message(_subject, [_pattern, pins, mailbox_messages], result, _positive) do
    [
      "Expected to receive `#{inspect result}` but it doesn't.",
      "Pinned variables: #{inspect pins}",
      "Process mailbox:",
      messages(mailbox_messages)
    ] |> Enum.join(@join_sym)
  end

  defp messages(mailbox_messages), do: Enum.map_join(mailbox_messages, @join_sym, &inspect/1)
end
