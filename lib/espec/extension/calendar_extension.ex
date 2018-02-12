defmodule Calendar.ISO.Extension do
  @moduledoc """
  A module to extend the calendar implementation that follows to ISO8601 with methods found in
  Elixir 1.5.1. This is to allow ESpec to support Elixir >= 1.3.4 more easily.
  """

  @type year :: 0..9999
  @type month :: 1..12
  @type day :: 1..31

  @seconds_per_minute 60
  @seconds_per_hour 60 * 60
  # Note that this does _not_ handle leap seconds.
  @seconds_per_day 24 * 60 * 60
  @microseconds_per_second 1_000_000
  @parts_per_day @seconds_per_day * @microseconds_per_second

  @days_per_nonleap_year 365
  @days_per_leap_year 366

  @doc """
  Returns the `t:Calendar.iso_days` format of the specified date.

  ## Examples

      iex> Calendar.ISO.naive_datetime_to_iso_days(0, 1, 1, 0, 0, 0, {0, 6})
      {0, {0, 86400000000}}
      iex> Calendar.ISO.naive_datetime_to_iso_days(2000, 1, 1, 12, 0, 0, {0, 6})
      {730485, {43200000000, 86400000000}}
      iex> Calendar.ISO.naive_datetime_to_iso_days(2000, 1, 1, 13, 0, 0, {0, 6})
      {730485, {46800000000, 86400000000}}

  """
  @spec naive_datetime_to_iso_days(
          Calendar.year(),
          Calendar.month(),
          Calendar.day(),
          Calendar.hour(),
          Calendar.minute(),
          Calendar.second(),
          Calendar.microsecond()
        ) :: Calendar.iso_days()
  def naive_datetime_to_iso_days(year, month, day, hour, minute, second, microsecond) do
    {date_to_iso_days(year, month, day), time_to_day_fraction(hour, minute, second, microsecond)}
  end

  @doc """
  Returns the normalized day fraction of the specified time.

  ## Examples

      iex> Calendar.ISO.time_to_day_fraction(0, 0, 0, {0, 6})
      {0, 86400000000}
      iex> Calendar.ISO.time_to_day_fraction(12, 34, 56, {123, 6})
      {45296000123, 86400000000}

  """
  @spec time_to_day_fraction(
          Calendar.hour(),
          Calendar.minute(),
          Calendar.second(),
          Calendar.microsecond()
        ) :: Calendar.day_fraction()
  def time_to_day_fraction(0, 0, 0, {0, _}) do
    {0, @parts_per_day}
  end

  def time_to_day_fraction(hour, minute, second, {microsecond, _}) do
    combined_seconds = hour * @seconds_per_hour + minute * @seconds_per_minute + second
    {combined_seconds * @microseconds_per_second + microsecond, @parts_per_day}
  end

  # Converts year, month, day to count of days since 0000-01-01.
  @doc false
  def date_to_iso_days(0, 1, 1) do
    0
  end

  def date_to_iso_days(1970, 1, 1) do
    719_528
  end

  def date_to_iso_days(year, month, day) when year in 0..9999 do
    true = day <= days_in_month(year, month)

    days_in_previous_years(year) + days_before_month(month) + leap_day_offset(year, month) + day -
      1
  end

  @doc """
  Returns how many days there are in the given year-month.

  ## Examples

      iex> Calendar.ISO.days_in_month(1900, 1)
      31
      iex> Calendar.ISO.days_in_month(1900, 2)
      28
      iex> Calendar.ISO.days_in_month(2000, 2)
      29
      iex> Calendar.ISO.days_in_month(2001, 2)
      28
      iex> Calendar.ISO.days_in_month(2004, 2)
      29
      iex> Calendar.ISO.days_in_month(2004, 4)
      30

  """
  @spec days_in_month(year, month) :: 28..31
  def days_in_month(year, month)

  def days_in_month(year, 2) do
    if leap_year?(year), do: 29, else: 28
  end

  def days_in_month(_, month) when month in [4, 6, 9, 11], do: 30
  def days_in_month(_, month) when month in 1..12, do: 31

  @spec leap_year?(year) :: boolean()
  def leap_year?(year) when is_integer(year) and year >= 0 do
    rem(year, 4) === 0 and (rem(year, 100) > 0 or rem(year, 400) === 0)
  end

  # Note that this function does not add the extra leap day for a leap year.
  # If you want to add that leap day when appropriate,
  # add the result of leap_day_offset/2 to the result of days_before_month/1.
  defp days_before_month(1), do: 0
  defp days_before_month(2), do: 31
  defp days_before_month(3), do: 59
  defp days_before_month(4), do: 90
  defp days_before_month(5), do: 120
  defp days_before_month(6), do: 151
  defp days_before_month(7), do: 181
  defp days_before_month(8), do: 212
  defp days_before_month(9), do: 243
  defp days_before_month(10), do: 273
  defp days_before_month(11), do: 304
  defp days_before_month(12), do: 334

  defp leap_day_offset(_year, month) when month < 3, do: 0

  defp leap_day_offset(year, _month) do
    if leap_year?(year), do: 1, else: 0
  end

  defp days_in_previous_years(0), do: 0

  defp days_in_previous_years(year) do
    previous_year = year - 1

    Integer.Extension.floor_div(previous_year, 4) -
      Integer.Extension.floor_div(previous_year, 100) +
      Integer.Extension.floor_div(previous_year, 400) + previous_year * @days_per_nonleap_year +
      @days_per_leap_year
  end

  @doc false
  def iso_days_to_unit({days, {parts, ppd}}, unit) do
    day_microseconds = days * @parts_per_day
    microseconds = div(parts * @parts_per_day, ppd)
    System.convert_time_unit(day_microseconds + microseconds, :microseconds, unit)
  end

  @doc false
  # Note: A method to call naive_datetime_to_iso_days, which Elixir 1.5.1 has, but 1.3.4 does not
  def to_iso_days(%{
        calendar: _calendar,
        year: year,
        month: month,
        day: day,
        hour: hour,
        minute: minute,
        second: second,
        microsecond: microsecond
      }) do
    Calendar.ISO.Extension.naive_datetime_to_iso_days(
      year,
      month,
      day,
      hour,
      minute,
      second,
      microsecond
    )
  end
end
