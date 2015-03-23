defmodule ESpec.Expect do

  def expect(do: value), do: {ESpec.To, value}
  def expect(value), do: {ESpec.To, value}

  def eq(value), do: {:eq, value}
  def eql(value), do: {:eql, value}

  def be(value), do: {:eq, value}

  def be(operator, value) do
    {:be, operator,  value}
  end

  def be_between(min, max), do: {:be_between, min, max}
  def be_close_to(value, delta), do: {:be_close, value, delta}

  def be_true(), do: {:be, :true, []}
  def be_false(), do: {:be, :false, []}
  def be_nil(), do: {:be, :nil, []}

  def raise_exception(), do: {:raise_exception, []}
  def raise_exception(exception, message), do: {:raise_exception, [exception, message]}
  def raise_exception(exception), do: {:raise_exception, [exception]}



end
