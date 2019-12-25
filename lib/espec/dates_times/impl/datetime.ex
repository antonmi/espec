defimpl ESpec.DatesTimes.DateTimeProtocol, for: DateTime do
  @moduledoc """
  A type which represents a date and time with timezone information (optional, UTC will
  be assumed for date/times with no timezone information provided).

  Functions that produce time intervals use UNIX epoch (or simly Epoch) as the
  default reference date. Epoch is defined as UTC midnight of January 1, 1970.

  Time intervals in this module don't account for leap seconds.
  """

  @spec to_comparison_units(DateTime.t()) :: non_neg_integer
  def to_comparison_units(%{std_offset: std_offset, utc_offset: utc_offset} = datetime) do
    microseconds =
      datetime
      |> Calendar.ISO.Extension.to_iso_days()
      |> Calendar.ISO.Extension.iso_days_to_unit(:microsecond)

    offset_microseconds = System.convert_time_unit(std_offset + utc_offset, :second, :microsecond)

    microseconds - offset_microseconds
  end
end
