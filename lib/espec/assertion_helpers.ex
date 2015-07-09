defmodule ESpec.AssertionHelpers do
  @moduledoc """
  Defines helper functions for modules which use ESpec.
  These functions wrap arguments for ESpec.ExpectTo module.
  See `ESpec.Assertion` module for corresponding 'assertion modules'
  """

  @elixir_types ~w(atom binary bitstring boolean float function integer list map number pid port reference tuple)a

  def eq(value), do: {ESpec.Assertions.Eq, value}
  def eql(value), do: {ESpec.Assertions.Eql, value}
  def be(value), do: {ESpec.Assertions.Eq, value}
  def be(operator, value), do: {ESpec.Assertions.Be, [operator,  value]}
  def be_between(min, max), do: {ESpec.Assertions.BeBetween, [min, max]}
  def be_close_to(value, delta), do: {ESpec.Assertions.BeCloseTo, [value, delta]}
  def match(value), do: {ESpec.Assertions.Match, value}

  def raise_exception(exception, message), do: {ESpec.Assertions.RaiseException, [exception, message]}
  def raise_exception(exception), do: {ESpec.Assertions.RaiseException, [exception]}
  def raise_exception(), do: {ESpec.Assertions.RaiseException, []}

  def throw_term(term), do: {ESpec.Assertions.ThrowTerm, [term]}
  def throw_term(), do: {ESpec.Assertions.ThrowTerm, []}

  def change(func, value), do: {ESpec.Assertions.ChangeTo, [func, value]}
  def change(func, before, value), do: {ESpec.Assertions.ChangeFromTo, [func, before, value]}

  def have_all(func), do: {ESpec.Assertions.Enum.HaveAll, func}
  def have_any(func), do: {ESpec.Assertions.Enum.HaveAny, func}
  def have_count_by(func, val), do: {ESpec.Assertions.Enum.HaveCountBy, [func, val]}
  def be_empty, do: {ESpec.Assertions.Enum.BeEmpty, []}
  def have_max(value), do: {ESpec.Assertions.Enum.HaveMax, value}
  def have_max_by(func, value), do: {ESpec.Assertions.Enum.HaveMaxBy, [func, value]}
  def have_min(value), do: {ESpec.Assertions.Enum.HaveMin, value}
  def have_min_by(func, value), do: {ESpec.Assertions.Enum.HaveMinBy, [func, value]}

  def have(val), do: {ESpec.Assertions.EnumString.Have, val}
  def have_at(pos, val), do: {ESpec.Assertions.EnumString.HaveAt, [pos, val]}

  def have_first(value), do: {ESpec.Assertions.ListString.HaveFirst, value}
  def have_last(value), do: {ESpec.Assertions.ListString.HaveLast, value}
  def have_count(value), do: {ESpec.Assertions.EnumString.HaveCount, value}
  def have_size(value), do: {ESpec.Assertions.EnumString.HaveCount, value}
  def have_length(value), do: {ESpec.Assertions.EnumString.HaveCount, value}

  def have_hd(value), do: {ESpec.Assertions.List.HaveHd, value}
  def have_tl(value), do: {ESpec.Assertions.List.HaveTl, value}

  def start_with(value), do: {ESpec.Assertions.String.StartWith, value}
  def end_with(value), do: {ESpec.Assertions.String.EndWith, value}
  def be_printable(), do: {ESpec.Assertions.String.BePrintable, []}
  def be_valid_string(), do: {ESpec.Assertions.String.BeValidString, []}

  def have_key(value), do: {ESpec.Assertions.Dict.HaveKey, value}
  def have_value(value), do: {ESpec.Assertions.Dict.HaveValue, value}
  def eq_dict(value), do: {ESpec.Assertions.Dict.EqDict, value}

  Enum.each @elixir_types, fn(type) ->
    def unquote(String.to_atom("be_#{type}"))() do
      {ESpec.Assertions.BeType, unquote(Macro.escape(type))}
    end
  end
  def be_nil, do: {ESpec.Assertions.BeType, :null}
  def be_function(arity), do: {ESpec.Assertions.BeType, [:function, arity]}

  def accepted(func, args \\ :any, opts \\ [pid: :any, count: :any]), do: {ESpec.Assertions.Accepted, [func, args, opts]}
end

