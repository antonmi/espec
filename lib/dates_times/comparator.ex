defmodule ESpec.DatesTimes.Comparator do
  @moduledoc false

  alias ESpec.DatesTimes.Delegator
  alias ESpec.DatesTimes.Types

  @units [:years, :months, :weeks, :days,
          :hours, :minutes, :seconds, :milliseconds, :microseconds]

  @spec diff(non_neg_integer, non_neg_integer, Types.time_units) :: integer
  def diff(a, a, granularity) when is_integer(a), do: zero(granularity)

  @spec diff(non_neg_integer, non_neg_integer, Types.time_units) :: integer
  def diff(a, b, granularity) when is_integer(a) and is_integer(b) and is_atom(granularity) do
    do_diff(a, b, granularity)
  end

  @spec diff(non_neg_integer, non_neg_integer, Types.time_units) :: integer
  def diff(a, b, granularity) do
    case {Delegator.to_comparison_units(a), Delegator.to_comparison_units(b)} do
      {{:error, _} = err, _} -> err
      {_, {:error, _} = err} -> err
      {au, bu} when is_integer(au) and is_integer(bu) -> diff(au, bu, granularity)
    end
  end

  defp do_diff(a, a, type),
    do: zero(type)
  defp do_diff(a, b, :microseconds),
    do: a - b
  defp do_diff(a, b, :milliseconds),
    do: div(a - b, 1_000)
  defp do_diff(a, b, :seconds),
    do: div(a - b, 1_000*1_000)
  defp do_diff(a, b, :minutes),
    do: div(a - b, 1_000*1_000*60)
  defp do_diff(a, b, :hours),
    do: div(a - b, 1_000*1_000*60*60)
  defp do_diff(a, b, :days),
    do: div(a - b, 1_000*1_000*60*60*24)
  defp do_diff(a, b, :weeks),
    do: div(a - b, 1_000*1_000*60*60*24*7)
  defp do_diff(a, b, :months),
    do: diff_months(a, b)
  defp do_diff(a, b, :years),
    do: diff_years(a, b)
  defp do_diff(_, _, granularity) when not granularity in @units,
    do: {:error, {:invalid_granularity, granularity}}

  defp diff_years(a, b) do
    {start_date, _} = :calendar.gregorian_seconds_to_datetime(div(a, 1_000*1_000))
    {end_date, _} = :calendar.gregorian_seconds_to_datetime(div(b, 1_000*1_000))
    if a > b do
      do_diff_years(end_date, start_date, 0)
    else
      do_diff_years(start_date, end_date, 0) * -1
    end
  end
  defp do_diff_years({y, _, _}, {y, _, _}, acc) do
    acc
  end
  defp do_diff_years({y1, m, d}, {y2, _, _} = ed, acc) when y1 < y2 do
    sd2 = {y1+1, m, d}
    if :calendar.valid_date(sd2) do
      sd2_secs = :calendar.datetime_to_gregorian_seconds({sd2,{0,0,0}})
      ed_secs = :calendar.datetime_to_gregorian_seconds({ed,{0,0,0}})
      if sd2_secs <= ed_secs do
        do_diff_years(sd2, ed, acc+1)
      else
        acc
      end
    else
      # This date is a leap day, so subtract a day and try again
      do_diff_years({y1, m, d-1}, ed, acc)
    end
  end

  defp diff_months(a, b) do
    {start_date, _} = :calendar.gregorian_seconds_to_datetime(div(a, 1_000*1_000))
    {end_date, _} = :calendar.gregorian_seconds_to_datetime(div(b, 1_000*1_000))
    if a > b do
      do_diff_months(end_date, start_date)
    else
      do_diff_months(start_date, end_date) * -1
    end
  end
  defp do_diff_months({y,m,_}, {y,m,_}), do: 0
  defp do_diff_months({y1, m1, d1}, {y2, m2, d2}) when y1 <= y2 and m1 < m2 do
    year_diff = y2 - y1
    month_diff = if d2 >= d1, do: m2 - m1, else: (m2-1)-m1
    (year_diff*12)+month_diff
  end
  defp do_diff_months({y1,m1,d1}, {y2,m2,d2}) when y1 < y2 and m1 > m2 do
    year_diff = y2 - (y1+1)
    month_diff =
      cond do
        d2 == d1 ->
          12 - (m1-m2)
        d2 > d1 ->
          12 - ((m1-1)-m2)
        d2 < d1 ->
          12 - (m1-m2)
      end
    (year_diff*12)+month_diff
  end
  defp do_diff_months({y1,m,d1}, {y2,m,d2}) when y1 < y2 do
    year_diff = y2 - (y1+1)
    month_diff =
      cond do
        d2 > d1 ->
          11
        :else ->
          12
      end
    (year_diff*12)+month_diff
  end
  defp zero(_type), do: 0
end
