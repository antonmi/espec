defimpl ESpec.DateTimeProtocol, for: DateTime do
  @moduledoc """
  A type which represents a date and time with timezone information (optional, UTC will
  be assumed for date/times with no timezone information provided).

  Functions that produce time intervals use UNIX epoch (or simly Epoch) as the
  default reference date. Epoch is defined as UTC midnight of January 1, 1970.

  Time intervals in this module don't account for leap seconds.
  """

  @epoch_seconds :calendar.datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}})

  @spec to_gregorian_microseconds(DateTime.t) :: non_neg_integer
  def to_gregorian_microseconds(%DateTime{microsecond: {us,_}} = date) do
    s = to_seconds(date, :zero)
    (s*(1_000*1_000)) + us
  end

  @spec to_seconds(DateTime.t, :epoch | :zero) :: integer | {:error, atom}
  defp to_seconds(%DateTime{} = date, :epoch) do
    case to_seconds(date, :zero) do
      {:error, _} = err -> err
      secs -> secs - @epoch_seconds
    end
  end
  defp to_seconds(%DateTime{} = date, :zero) do
    total_offset = total_offset(date.std_offset, date.utc_offset) * -1
    date = %{date | :time_zone => "Etc/UTC", :zone_abbr => "UTC", :std_offset => 0, :utc_offset => 0}
    date = shift(date, seconds: total_offset)
    utc_to_secs(date)
  end
  defp to_seconds(_, _), do: {:error, :badarg}

  defp utc_to_secs(%DateTime{:year => y, :month => m, :day => d, :hour => h, :minute => mm, :second => s}) do
    :calendar.datetime_to_gregorian_seconds({{y,m,d},{h,mm,s}})
  end

  defp total_offset(std_offset, utc_offset) do
    utc_offset + std_offset
  end

  @doc """
  Shifts the given DateTime based on a series of options.

  See docs for Timex.shift/2 for details.
  """
  @spec shift(DateTime.t, list({atom(), term})) :: DateTime.t | {:error, term}
  def shift(%DateTime{} = datetime, shifts) when is_list(shifts) do
    apply_shifts(datetime, shifts)
  end
  defp apply_shifts(datetime, []), do: datetime
  defp apply_shifts(datetime, [{unit, 0} | rest]) when is_atom(unit),
    do: apply_shifts(datetime, rest)
  defp apply_shifts(datetime, [{unit, value} | rest]) when is_atom(unit) and is_integer(value) do
    shifted = shift_by(datetime, value, unit)
    apply_shifts(shifted, rest)
  end
  defp apply_shifts({:error, _} = err, _), do: err

  defp shift_by(
    %DateTime{year: y, month: m, day: d,
              hour: h, minute: mm, second: s},
              value, :seconds) do
    :calendar.datetime_to_gregorian_seconds({{y,m,d},{h,mm,s}}) + value
    |> :calendar.gregorian_seconds_to_datetime
  end
end
