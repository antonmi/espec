defmodule ESpec.Assertions.Accepted do
  @moduledoc """
  Defines 'accepted' assertion.

  it do: expect(SomeModule).to accepted(:func)
  """
  use ESpec.Assertions.Interface

  defp match(subject, [func, args, opts]) do
    pid = Keyword.get(opts, :pid) || :any
    opts_count = Keyword.get(opts, :count) || :any

    count = get_count(subject, func, args, pid)

    matched =
      if opts_count == :any do
        count >= 1
      else
        count == opts_count
      end

    {matched, count}
  end

  defp get_count(subject, func, args, pid) do
    Enum.count(:meck.history(subject), fn el ->
      cond do
        pid == :any && args == :any -> check_any_any(el, subject, func)
        pid == :any -> check_any_pid(el, subject, func, args)
        args == :any -> check_any_args(el, subject, func, pid)
        true -> check_else(el, subject, func, pid, args)
      end
    end)
  end

  defp check_any_any(el, subject, func) do
    case el do
      {_, {^subject, ^func, _}, _return} -> true
      _ -> false
    end
  end

  defp check_any_pid(el, subject, func, args) do
    case el do
      {_, {^subject, ^func, ^args}, _return} -> true
      _ -> false
    end
  end

  defp check_any_args(el, subject, func, pid) do
    case el do
      {^pid, {^subject, ^func, _}, _return} -> true
      _ -> false
    end
  end

  defp check_else(el, subject, func, pid, args) do
    case el do
      {^pid, {^subject, ^func, ^args}, _return} -> true
      _ -> false
    end
  end

  defp success_message(subject, [func, args, opts], _result, positive) do
    pid = Keyword.get(opts, :pid) || :any
    opts_count = Keyword.get(opts, :count) || :any
    count = if opts_count == :any, do: "at least once", else: "`#{opts_count}` times"
    to = if positive, do: "accepted", else: "didn't accept"

    "`#{inspect(subject)}` #{to} `#{inspect(func)}` with `#{inspect(args)}` in process `#{
      inspect(pid)
    }` #{count}."
  end

  defp error_message(subject, [func, args, opts], result, positive) do
    to = if positive, do: "to", else: "not to"
    but = "it accepted the function `#{result}` times"
    pid = Keyword.get(opts, :pid) || :any
    opts_count = Keyword.get(opts, :count) || :any
    count = if opts_count == :any, do: "at least once", else: "`#{opts_count}` times"

    "Expected `#{inspect(subject)}` #{to} accept `#{inspect(func)}` with `#{inspect(args)}` in process `#{
      inspect(pid)
    }` #{count}, but #{but}."
  end
end
