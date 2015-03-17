defmodule ESpec do

  Module.register_attribute __MODULE__, :group_level, accumulate: true

  defmacro __using__(_arg) do
    quote do
      {:ok, var!(buffer)} = start_buffer([])
      import unquote(__MODULE__)

      Module.register_attribute __MODULE__, :specs, accumulate: true
      Module.register_attribute __MODULE__, :groups, accumulate: true


      @before_compile unquote(__MODULE__)

      def run do
        IO.puts "Running tests #{inspect(@specs)}"
        ESpec.Runner.run(@specs, __MODULE__)
      end

    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def specs, do: @specs
      def groups, do: @groups
    end
  end


  defmacro it(description, do: block) do
    function = String.to_atom(description)
    quote do
      @specs { unquote(function), unquote(description) }
      def unquote(function)(), do: unquote(block)
    end
  end

  defmacro describe(description, body) do

    quote do
      # IO.puts(inspect @groups)
      desc = unquote(description)
      put_buffer var!(buffer), "1"
      IO.puts(desc)
      group = { %ESpec.Group{ description: desc } }

      @groups group
      unquote(body)
      # @groups prev
    end
  end

  def start_buffer(state), do: Agent.start_link(fn -> state end)
  def stop_buffer(buff), do: Agent.stop(buff)
  def put_buffer(buff, content), do: Agent.update(buff, &[content | &1])
  def render(buff), do: Agent.get(buff, &(&1)) |> Enum.reverse |> Enum.join("")

end
