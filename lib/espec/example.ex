defmodule ESpec.Example do
  @moduledoc """
  Defines macros 'example' and 'it'.
  These macros defines function with random name which will be called when example runs.
  Example structs %ESpec.Example are accumulated in @examples attribute
  """

  @doc """
  Expampe struct.
  description - the description of example,
  module - spec module,
  function - random function name,
  opts - options,
  file - spec file path,
  line - the line where example is defined,
  context - example context. Accumulator for 'contexts' and 'lets',
  shared - marks example as shared,
  status - example status (:new, :success, :failure, :pending),
  result - the value returned by example block or the pending message,
  error - store an error,
  duration - test duration.
  """
  defstruct description: "", module: nil, function: nil, opts: [],
            file: nil, line: nil, context: [], shared: false, async: false,
            status: :new, result: nil, error: nil, duration: 0

  @doc "Context descriptions."
  def context_descriptions(%__MODULE__{context: context, description: _description, function: _function}) do
    context
    |> Enum.filter(fn(struct) -> struct.__struct__ == ESpec.Context end)
    |> Enum.map(&(&1.description))
  end

  @doc "Filters success examples."
  def success(results), do: Enum.filter(results, &(&1.status == :success))

  @doc "Filters failed examples."
  def failure(results), do: Enum.filter(results, &(&1.status === :failure))

  @doc "Filters pending examples."
  def pendings(results), do: Enum.filter(results, &(&1.status === :pending))

  @doc "Extracts specific structs from example context."
  def extract_befores(example), do: extract(example.context, [ESpec.Before])
  def extract_lets(example), do: extract(example.context, [ESpec.Let])
  def extract_finallies(example), do: extract(example.context, [ESpec.Finally])
  def extract_contexts(example), do: extract(example.context, [ESpec.Context])

  @doc "Extracts example options."
  def extract_option(example, option) do
    contexts = ESpec.Example.extract_contexts(example)
    opts = List.flatten(example.opts ++ Enum.reverse(Enum.map(contexts, &(&1.opts))))
    opt = Enum.find(opts, fn({k, _v}) -> k == option end)
    if opt do
     {^option, value} = opt
      value
    else
      nil
    end
  end

  defp extract(context, modules) do
    Enum.filter(context, &Enum.member?(modules, &1.__struct__))
  end

  @doc "Message for skipped examples."
  def skip_message(example) do
    skipper = extract_option(example, :skip)
    if skipper === true do
      "Temporarily skipped without a reason."
    else
      "Temporarily skipped with: #{skipper}."
    end
  end

  @doc "Message for pending examples."
  def pending_message(example) do
    if example.opts[:pending] === true do
      "Pending example."
    else
      "Pending with message: #{example.opts[:pending]}."
    end
  end
end
