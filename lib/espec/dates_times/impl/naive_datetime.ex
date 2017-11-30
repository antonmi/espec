defimpl ESpec.DatesTimes.DateTimeProtocol, for: NaiveDateTime do
  @moduledoc """
  This module represents all functions specific to creating/manipulating/comparing Dates (year/month/day)
  """

  @spec to_comparison_units(NaiveDateTime.t) :: non_neg_integer
  def to_comparison_units(date), do: to_gregorian_microseconds(date)

  @spec to_gregorian_microseconds(NaiveDateTime.t) :: non_neg_integer
  def to_gregorian_microseconds(%NaiveDateTime{microsecond: {us, _}} = naive_datetime) do
    s = to_seconds(naive_datetime)
    (s * (1_000 * 1_000)) + us
  end

  defp to_seconds(%NaiveDateTime{year: y, month: m, day: d, hour: h, minute: mm, second: s}),
    do: :calendar.datetime_to_gregorian_seconds({{y, m, d}, {h, mm, s}})
end
