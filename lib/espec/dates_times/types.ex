defmodule ESpec.DatesTimes.Types do
  # Complex types
  @type time_units ::
          :microsecond | :millisecond | :second | :minute | :hour | :day | :week | :year
  @type calendar_types :: Date.t() | DateTime.t() | NaiveDateTime.t() | Time.t()
end
