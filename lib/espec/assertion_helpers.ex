defmodule ESpec.AssertionHelpers do
  @moduledoc """
  Defines helper functions for modules which use ESpec.
  These functions wrap arguments for ESpec.ExpectTo module.
  See `ESpec.Assertion` module for corresponding 'assertion modules'
  """

  alias ESpec.Assertions

  @elixir_types ~w(atom binary bitstring boolean float function integer list map number pid port reference tuple)a

  def eq(value), do: {Assertions.Eq, value}
  def eql(value), do: {Assertions.Eql, value}
  def be(value), do: {Assertions.Eq, value}
  def be(operator, value), do: {Assertions.Be, [operator,  value]}
  def be_between(min, max), do: {Assertions.BeBetween, [min, max]}
  def be_close_to(value, delta), do: {Assertions.BeCloseTo, [value, delta]}
  def match(value), do: {Assertions.Match, value}

  def be_true, do: {Assertions.Boolean.BeTrue, []}
  def be_false, do: {Assertions.Boolean.BeFalse, []}
  def be_truthy, do: {Assertions.Boolean.BeTruthy, []}
  def be_falsy, do: {Assertions.Boolean.BeFalsy, []}

  def raise_exception(exception, message) when is_atom(exception) and is_binary(message) do
    {Assertions.RaiseException, [exception, message]}
  end
  def raise_exception(exception) when is_atom(exception), do: {Assertions.RaiseException, [exception]}
  def raise_exception(), do: {Assertions.RaiseException, []}

  def throw_term(term), do: {Assertions.ThrowTerm, [term]}
  def throw_term(), do: {Assertions.ThrowTerm, []}

  def change(func) when is_function(func), do: {Assertions.Change, [func]}
  def change(func, value) when is_function(func) and is_integer(value), do: {Assertions.ChangeTo, [func, value]}
  def change(func, value) when is_function(func) and is_list(value), do: {Assertions.ChangeBy, [func, value]}
  def change(func, before, value) when is_function(func), do: {Assertions.ChangeFromTo, [func, before, value]}

  def have_all(func) when is_function(func), do: {Assertions.Enum.HaveAll, func}
  def have_any(func) when is_function(func), do: {Assertions.Enum.HaveAny, func}
  def have_count_by(func, val) when is_function(func), do: {Assertions.Enum.HaveCountBy, [func, val]}
  def be_empty, do: {Assertions.Enum.BeEmpty, []}
  def have_max(value), do: {Assertions.Enum.HaveMax, value}
  def have_max_by(func, value) when is_function(func), do: {Assertions.Enum.HaveMaxBy, [func, value]}
  def have_min(value), do: {Assertions.Enum.HaveMin, value}
  def have_min_by(func, value) when is_function(func), do: {Assertions.Enum.HaveMinBy, [func, value]}

  def match_list(value) when is_list(value), do: {Assertions.ContainExactly, value}
  def contain_exactly(value) when is_list(value), do: {Assertions.ContainExactly, value}

  def have(val), do: {Assertions.EnumString.Have, val}
  def have_at(pos, val) when is_number(pos), do: {Assertions.EnumString.HaveAt, [pos, val]}

  def have_first(value), do: {Assertions.ListString.HaveFirst, value}
  def have_last(value), do: {Assertions.ListString.HaveLast, value}
  def have_count(value), do: {Assertions.EnumString.HaveCount, value}
  def have_size(value), do: {Assertions.EnumString.HaveCount, value}
  def have_length(value), do: {Assertions.EnumString.HaveCount, value}

  def have_hd(value), do: {Assertions.List.HaveHd, value}
  def have_tl(value), do: {Assertions.List.HaveTl, value}

  def have_byte_size(value), do: {Assertions.Binary.HaveByteSize, value}

  def start_with(value), do: {Assertions.String.StartWith, value}
  def end_with(value), do: {Assertions.String.EndWith, value}
  def be_printable(), do: {Assertions.String.BePrintable, []}
  def be_valid_string(), do: {Assertions.String.BeValidString, []}
  def be_blank(), do: {Assertions.String.BeBlank, []}

  def have_key(value), do: {Assertions.Map.HaveKey, value}
  def have_value(value), do: {Assertions.Map.HaveValue, value}

  Enum.each @elixir_types, fn(type) ->
    def unquote(String.to_atom("be_#{type}"))() do
      {Assertions.BeType, unquote(Macro.escape(type))}
    end
  end
  def be_nil, do: {Assertions.BeType, :null}
  def be_function(arity), do: {Assertions.BeType, [:function, arity]}
  def be_struct, do: {Assertions.BeType, :struct}
  def be_struct(name), do: {Assertions.BeType, [:struct, name]}

  def accepted(func, args \\ :any, opts \\ [pid: :any, count: :any]), do: {Assertions.Accepted, [func, args, opts]}

  def be_ok_result(), do: {Assertions.Result.BeOkResult, []}
  def be_error_result(), do: {Assertions.Result.BeErrorResult, []}
end
