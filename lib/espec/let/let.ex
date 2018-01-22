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

  @doc "Allows to define several 'lets' at once"
  defmacro let(keyword) when is_list(keyword) do
    if Keyword.keyword?(keyword) do
      Enum.map(keyword, fn {var, block} -> do_let(var, block) end)
    else
      raise "Argument must be a Keyword"
    end
  end

  @doc "Defines overridable lets in shared examples"
  defmacro let_overridable(keywords) when is_list(keywords) do
    if Keyword.keyword?(keywords) do
      Enum.map(keywords, fn {var, block} -> do_let(var, block, true) end)
    else
      Enum.map(keywords, &do_let(&1, nil, true))
    end
  end

  defmacro let_overridable(var), do: do_let(var, nil, true)

  defp do_let(var, block, shared \\ false) do
    block = Macro.escape(quote(do: unquote(block)), unquote: true)

    quote bind_quoted: [block: block, var: var, shared: shared] do
      function = ESpec.Let.Impl.random_let_name()

      if shared && !@shared do
        raise ESpec.LetError, ESpec.Let.__overridable_error_message__(var, __MODULE__)
      end

      tail = @context

      head = %ESpec.Let{
        var: var,
        module: __MODULE__,
        shared_module: __MODULE__,
        function: function,
        shared: shared
      }

      def unquote(function)(var!(shared)) do
        var!(shared)
        unquote(block)
      end

      @context [head | tail]

      unless Module.defines?(__MODULE__, {var, 0}, :def) do
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

  @doc "Allows to define several 'lets' at once"
  defmacro let!(keyword) when is_list(keyword) do
    before_block =
      keyword
      |> Keyword.keys()
      |> Enum.map(fn key ->
        quote do: unquote(key)()
      end)

    quote do
      let unquote(keyword)

      before do
        unquote(before_block)
      end
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

  @doc """
  Defines 'let' for success result tuple.
  """
  defmacro let_ok(var, do: block) do
    do_result_let(var, block, :ok, false)
  end

  @doc """
  Allows to define several 'let_ok's at once
  """
  defmacro let_ok(keyword) when is_list(keyword) do
    if Keyword.keyword?(keyword) do
      Enum.map(keyword, fn {var, block} -> do_result_let(var, block, :ok, false) end)
    else
      raise "Argument must be a Keyword"
    end
  end

  @doc """
  Defines 'let!' for success result tuple.
  """
  defmacro let_ok!(var, do: block) do
    do_result_let(var, block, :ok, true)
  end

  @doc """
  Allows to define several 'let_ok!'s at once
  """
  defmacro let_ok!(keyword) when is_list(keyword) do
    if Keyword.keyword?(keyword) do
      Enum.map(keyword, fn {var, block} -> do_result_let(var, block, :ok, true) end)
    else
      raise "Argument must be a Keyword"
    end
  end

  @doc """
  Defines 'let' for error result tuple.
  """
  defmacro let_error(var, do: block) do
    do_result_let(var, block, :error, false)
  end

  @doc """
  Allows to define several 'let_error's at once
  """
  defmacro let_error(keyword) when is_list(keyword) do
    if Keyword.keyword?(keyword) do
      Enum.map(keyword, fn {var, block} -> do_result_let(var, block, :error, false) end)
    else
      raise "Argument must be a Keyword"
    end
  end

  @doc """
  Defines 'let!' for error result tuple.
  """
  defmacro let_error!(var, do: block) do
    do_result_let(var, block, :error, true)
  end

  @doc """
  Allows to define several 'let_error!'s at once
  """
  defmacro let_error!(keyword) when is_list(keyword) do
    if Keyword.keyword?(keyword) do
      Enum.map(keyword, fn {var, block} -> do_result_let(var, block, :error, true) end)
    else
      raise "Argument must be a Keyword"
    end
  end

  defp do_result_let(var, block, key, bang?) do
    new_block =
      quote do
        {unquote(key), result} = unquote(block)
        result
      end

    if bang? do
      quote do: let!(unquote(var), do: unquote(new_block))
    else
      quote do: let(unquote(var), do: unquote(new_block))
    end
  end

  @doc false
  def __overridable_error_message__(var, module) do
    "You are trying to define overridable let `#{var}` in #{module}. Defining of overridable lets is allowed only in shared modules"
  end
end
