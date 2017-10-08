defimpl ESpec.DatesTimes.DateTimeProtocol, for: Time do
  @moduledoc """
  This module represents all functions specific to creating/manipulating/comparing Times (year/month/day)
  """

  def to_comparison_units(date), do: to_gregorian_microseconds(date)

  @spec to_gregorian_microseconds(Time.t) :: non_neg_integer
  def to_gregorian_microseconds(time), do: (to_microseconds(time, :zero))

  defp to_microseconds(%Time{hour: h, minute: mm, second: s, microsecond: {usec, _precision}}, :zero) do
    (h * 36 * 100_000_000) + (mm * 60 * 1_000_000) + (s * 1_000_000) + usec
  end
end
