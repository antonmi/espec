defmodule Integer.Extension do
  @moduledoc """
  Functions for working with integers.
  """

  @doc """
  Performs a floored integer division.

  Raises an `ArithmeticError` exception if one of the arguments is not an
  integer, or when the `divisor` is `0`.

  `Integer.floor_div/2` performs *floored* integer division. This means that
  the result is always rounded towards negative infinity.

  If you want to perform truncated integer division (rounding towards zero),
  use `Kernel.div/2` instead.

  ## Examples

      iex> Integer.floor_div(5, 2)
      2
      iex> Integer.floor_div(6, -4)
      -2
      iex> Integer.floor_div(-99, 2)
      -50

  """
  @spec floor_div(integer, neg_integer | pos_integer) :: integer
  def floor_div(dividend, divisor) do
    if (dividend * divisor < 0) and rem(dividend, divisor) != 0 do
      div(dividend, divisor) - 1
    else
      div(dividend, divisor)
    end
  end
end
