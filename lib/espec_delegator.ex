defmodule ESpec.Delegator do
  @moduledoc """
  The ESpec.Delegator module. Used to delegate methods to the correct protocol
  implementation.
  """

  @doc """
  Convert a date/time value to (gregorian) microseconds
  (microseconds since start of year zero if gregorian)
  """
  @spec to_comparison_units(Types.valid_datetime) :: non_neg_integer | {:error, term}
  defdelegate to_comparison_units(datetime), to: ESpec.DatesTimes.DateTimeProtocol
end
