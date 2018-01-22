defmodule DateTime.Extension do
  @moduledoc """
  A module to extend the calendar implementation that follows to ISO8601 with methods found in
  Elixir 1.5.1. This is to allow ESpec to support Elixir >= 1.3.4 more easily.
  """

  defstruct [
    :year,
    :month,
    :day,
    :hour,
    :minute,
    :second,
    :time_zone,
    :zone_abbr,
    :utc_offset,
    :std_offset,
    microsecond: {0, 0},
    calendar: Calendar.ISO
  ]

  @type t :: %__MODULE__{
          year: Calendar.year(),
          month: Calendar.month(),
          day: Calendar.day(),
          calendar: Calendar.calendar(),
          hour: Calendar.hour(),
          minute: Calendar.minute(),
          second: Calendar.second(),
          microsecond: Calendar.microsecond(),
          time_zone: Calendar.time_zone(),
          zone_abbr: Calendar.zone_abbr(),
          utc_offset: Calendar.utc_offset(),
          std_offset: Calendar.std_offset()
        }

  @doc """
  Converts the given `NaiveDateTime` to `DateTime`.

  It expects a time zone to put the NaiveDateTime in.
  Currently it only supports "Etc/UTC" as time zone.

  ## Examples

      iex> {:ok, datetime} = DateTime.from_naive(~N[2016-05-24 13:26:08.003], "Etc/UTC")
      iex> datetime
      #DateTime<2016-05-24 13:26:08.003Z>

  """
  @spec from_naive(NaiveDateTime.t(), Calendar.time_zone()) :: {:ok, t}
  def from_naive(naive_datetime, time_zone)

  def from_naive(
        %NaiveDateTime{
          calendar: calendar,
          hour: hour,
          minute: minute,
          second: second,
          microsecond: microsecond,
          year: year,
          month: month,
          day: day
        },
        "Etc/UTC"
      ) do
    {:ok,
     %DateTime{
       calendar: calendar,
       year: year,
       month: month,
       day: day,
       hour: hour,
       minute: minute,
       second: second,
       microsecond: microsecond,
       std_offset: 0,
       utc_offset: 0,
       zone_abbr: "UTC",
       time_zone: "Etc/UTC"
     }}
  end

  @doc """
  Converts the given `NaiveDateTime` to `DateTime`.

  It expects a time zone to put the NaiveDateTime in.
  Currently it only supports "Etc/UTC" as time zone.

  ## Examples

      iex> DateTime.from_naive!(~N[2016-05-24 13:26:08.003], "Etc/UTC")
      #DateTime<2016-05-24 13:26:08.003Z>

  """
  @spec from_naive!(NaiveDateTime.t(), Calendar.time_zone()) :: t
  def from_naive!(naive_datetime, time_zone) do
    case from_naive(naive_datetime, time_zone) do
      {:ok, datetime} ->
        datetime

      {:error, reason} ->
        raise ArgumentError,
              "cannot parse #{inspect(naive_datetime)} to datetime, reason: #{inspect(reason)}"
    end
  end
end
