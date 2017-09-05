defimpl ESpec.DateTimeProtocol, for: Date do
  @moduledoc """
  This module represents all functions specific to creating/manipulating/comparing Dates (year/month/day)
  """
  @epoch_seconds :calendar.datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}})

  @spec to_gregorian_microseconds(Date.t) :: non_neg_integer
  def to_gregorian_microseconds(date), do: (to_seconds(date, :zero) * (1_000*1_000))

  defp to_seconds(%Date{year: y, month: m, day: d}, :zero),
    do: :calendar.datetime_to_gregorian_seconds({{y,m,d},{0,0,0}})
  defp to_seconds(%Date{year: y, month: m, day: d}, :epoch),
    do: (:calendar.datetime_to_gregorian_seconds({{y,m,d},{0,0,0}}) - @epoch_seconds)
end
