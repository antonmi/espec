defmodule ESpec.AssertionHelpers do
  @moduledoc """
  Defines helper functions for modules which use ESpec.
  These fucntions wraps arguments for ESpec.ExpectTo module.
  See `ESpec.Assertion` module for corresponding 'assertion modules'
  """

  @elixir_types ~w(atom binary bitstring boolean float function integer list map number pid port reference tuple)a

  def eq(value), do: {:eq, value}
  def eql(value), do: {:eql, value}
  def be(value), do: {:eq, value}
  def be(operator, value), do: {:be, [operator,  value]}
  def be_between(min, max), do: {:be_between, [min, max]}
  def be_close_to(value, delta), do: {:be_close, [value, delta]}
  def match(value), do: {:match, value}
  
  def raise_exception(exception, message), do: {:raise_exception, [exception, message]}
  def raise_exception(exception), do: {:raise_exception, [exception]}
  def raise_exception(), do: {:raise_exception, []}

  def throw_term(term), do: {:throw_term, [term]}
  def throw_term(), do: {:throw_term, []}

  def change(func, value), do: {:change_to, [func, value]}
  def change(func, before, value), do: {:change_from_to, [func, before, value]}

  def have_all(func), do: {:have_all, func}
  def have_any(func), do: {:have_any, func}
  def have_at(pos, val), do: {:have_at, [pos, val]}
  def have_count(val), do: {:have_count, val}
  def have_count_by(func, val), do: {:have_count_by, [func, val]}
  def have(val), do: {:have, val}
  def be_empty, do: {:be_empty, []}
  def have_max(value), do: {:have_max, value}
  def have_max_by(func, value), do: {:have_max_by, [func, value]}
  def have_min(value), do: {:have_min, value}
  def have_min_by(func, value), do: {:have_min_by, [func, value]}

  def have_first(value), do: {:have_first, value}
  def have_last(value), do: {:have_last, value}
  def have_hd(value), do: {:have_hd, value}
  def have_tl(value), do: {:have_tl, value}

  
  Enum.each @elixir_types, fn(type) -> 
    def unquote(String.to_atom("be_#{type}"))() do
      {:be_type, unquote(Macro.escape(type))}
    end
  end
  def be_nil, do: {:be_type, :null}
  def be_function(arity), do: {:be_type, [:function, arity]}

  def accepted(func, args \\ [], pid \\ self), do: {:accepted, [func, args, pid]}

end