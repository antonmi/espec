defimpl ESpec.DatesTimes.DateTimeProtocol, for: Date do
  @moduledoc """
  This module represents all functions specific to creating/manipulating/comparing Dates (year/month/day)
  """

  @spec to_comparison_units(Date.t) :: non_neg_integer
  def to_comparison_units(date), do: to_gregorian_microseconds(date)

  @spec to_gregorian_microseconds(Date.t) :: non_neg_integer
  def to_gregorian_microseconds(date), do: (to_seconds(date) * (1_000*1_000))

  defp to_seconds(%Date{year: y, month: m, day: d}),
    do: :calendar.datetime_to_gregorian_seconds({{y,m,d},{0,0,0}})
end
