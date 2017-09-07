defimpl ESpec.DateTimeProtocol, for: DateTime do
  @moduledoc """
  A type which represents a date and time with timezone information (optional, UTC will
  be assumed for date/times with no timezone information provided).

  Functions that produce time intervals use UNIX epoch (or simly Epoch) as the
  default reference date. Epoch is defined as UTC midnight of January 1, 1970.

  Time intervals in this module don't account for leap seconds.
  """

  @epoch_seconds :calendar.datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}})

  def to_comparison_units(%{std_offset: std_offset, utc_offset: utc_offset} = datetime) do
    microseconds = datetime
                   |> to_iso_days()
                   |> Calendar.ISO.iso_days_to_unit(:microsecond)
    offset_microseconds = System.convert_time_unit(std_offset + utc_offset, :second, :microsecond)
    (microseconds - offset_microseconds)
  end

  defp to_iso_days(%{calendar: calendar, year: year, month: month, day: day,
                     hour: hour, minute: minute, second: second, microsecond: microsecond}) do
    calendar.naive_datetime_to_iso_days(year, month, day, hour, minute, second, microsecond)
  end
end
