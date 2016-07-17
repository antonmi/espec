defmodule ESpec.Let do
  @moduledoc """
  Defines 'let', 'let!' and 'subject' macros.
  'let' and 'let!' macros define named functions with cached return values.
  The 'let' evaluate block in runtime when called first time.
  The 'let!' evaluates as a before block just after all 'befores' for example.
  The 'subject' macro is just an alias for let to define `subject`.
  """

  @doc "Struct keeps the name of variable and random function name."
  defstruct var: nil, module: nil, function: nil, shared: false, shared_module: nil

  @doc """
  The macro defines function with random name which returns block value.
  That function will be called when example is run.
  The function will place the block value to the Agent dict.
  """
  defmacro let(var, do: block), do: do_let(var, block)

  @doc "Defines overridable lets in shared examples"
  defmacro let_overridable(keywords) when is_list keywords do
    if Keyword.keyword?(keywords) do
      Enum.map(keywords, fn{var, block} -> do_let(var, block, true) end)
    else
      Enum.map(keywords, &do_let(&1, nil, true))
    end
  end
  
  defmacro let_overridable(var), do: do_let(var, nil, true)

  defp do_let(var, block, shared \\ false) do
    function = ESpec.Let.Impl.random_let_name

    quote do
      if unquote(shared) && !@shared do
        raise ESpec.LetError, ESpec.Let.__overridable_error_message__(unquote(var), __MODULE__)
      end

      tail = @context
      head = %ESpec.Let{var: unquote(var), module: __MODULE__, shared_module: __MODULE__, function: unquote(function), shared: unquote(shared)}

      def unquote(function)(var!(shared)) do
        var!(shared)
        unquote(block)
      end

      @context [head | tail]

      unless Module.defines?(__MODULE__, {unquote(var), 0}, :def) do
        def unquote(var)() do
          ESpec.Let.Impl.let_eval(__MODULE__, unquote(var))
        end
      end
    end
  end

  @doc "let! evaluate block like `before`"
  defmacro let!(var, do: block) do
    quote do
      let unquote(var), do: unquote(block)
      before do: unquote(var)()
    end
  end

  @doc "Defines 'subject'."
  defmacro subject(do: block) do
    quote do: let(:subject, do: unquote(block))
  end

  @doc "Defines 'subject'."
  defmacro subject(var) do
    quote do: let(:subject, do: unquote(var))
  end

  @doc "Defines 'subject!'."
  defmacro subject!(do: block) do
    quote do: let!(:subject, do: unquote(block))
  end

  @doc "Defines 'subject!'."
  defmacro subject!(var) do
    quote do: let!(:subject, do: unquote(var))
  end

  @doc """
  Defines 'subject' with name.
  It is just an alias for 'let'.
  """
  defmacro subject(var, do: block) do
    quote do: let(unquote(var), do: unquote(block))
  end

  @doc """
  Defines 'subject!' with name.
  It is just an alias for 'let!'.
  """
  defmacro subject!(var, do: block) do
    quote do: let!(unquote(var), do: unquote(block))
  end

  @doc false
  def __overridable_error_message__(var, module) do
    "You are trying to define overridable let `#{var}` in #{module}. Defining of overridable lets is allowed only in shared modules"
  end
end
