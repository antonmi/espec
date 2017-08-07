defmodule ESpec.Delegator do
  @moduledoc """
  The ESpec.Delegator module. Used to delegate methods to the correct protocol
  implementation.
  """

  @doc """
  Convert a date/time value to gregorian microseconds (microseconds since start of year zero)
  """
  @spec to_gregorian_microseconds(Types.valid_datetime) :: non_neg_integer | {:error, term}
  defdelegate to_gregorian_microseconds(datetime), to: ESpec.Protocol
end
