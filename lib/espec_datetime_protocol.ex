defprotocol ESpec.DateTimeProtocol do
  @moduledoc """
  This protocol defines the API for functions which take a `Date`,
  `NaiveDateTime`, or `DateTime` as input.
  """
  alias ESpec.Types

  @doc """
  Convert a date/time value to gregorian microseconds (microseconds since the start of year zero)
  """
  @spec to_gregorian_microseconds(Types.valid_datetime) :: non_neg_integer | {:error, term}
  def to_gregorian_microseconds(datetime)
end
