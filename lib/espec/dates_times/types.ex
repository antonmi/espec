defmodule ESpec.DatesTimes.Types do
  # Complex types
  @type time_units :: :microseconds | :milliseconds | :seconds | :minutes | :hours | :days | :weeks | :years
  @type calendar_types :: Date.t | DateTime.t | NaiveDateTime.t | Time.t
end
