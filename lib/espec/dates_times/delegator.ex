defmodule ESpec.DatesTimes.Delegator do
  alias ESpec.DatesTimes.Types

  @moduledoc """
  The ESpec.DateTimes.Delegator module. Used to delegate methods to the correct protocol
  implementation.
  """

  @doc """
  Convert a date/time value to (gregorian) microseconds
  (microseconds since start of year zero if gregorian)
  """

  @spec to_comparison_units(Types.calendar_types()) :: non_neg_integer | {:error, term}
  defdelegate to_comparison_units(calendar_type), to: ESpec.DatesTimes.DateTimeProtocol
end
