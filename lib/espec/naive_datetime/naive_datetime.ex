defimpl ESpec.DateTimeProtocol, for: NaiveDateTime do
  @moduledoc """
  This module represents all functions specific to creating/manipulating/comparing Dates (year/month/day)
  """
  @epoch_seconds :calendar.datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}})

  @spec to_gregorian_seconds(NaiveDateTime.t) :: non_neg_integer
  def to_gregorian_seconds(naive_datetime), do: to_seconds(naive_datetime, :zero)

  @spec to_gregorian_microseconds(NaiveDateTime.t) :: non_neg_integer
  def to_gregorian_microseconds(naive_datetime), do: (to_seconds(naive_datetime, :zero) * (1_000*1_000))

  defp to_seconds(%NaiveDateTime{year: y, month: m, day: d, hour: h, minute: mm, second: s}, :zero),
    do: :calendar.datetime_to_gregorian_seconds({{y,m,d},{h,mm,s}})
  defp to_seconds(%NaiveDateTime{year: y, month: m, day: d, hour: h, minute: mm, second: s}, :epoch),
    do: (:calendar.datetime_to_gregorian_seconds({{y,m,d},{h,mm,s}}) - @epoch_seconds)
end
