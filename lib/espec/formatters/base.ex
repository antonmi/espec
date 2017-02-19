defmodule ESpec.Formatters.Base do
  defmacro __using__(_opts) do
    quote  do
      use GenServer
      import ESpec.Formatters.WriteOutput

      def init(opts) do
        opts = if opts[:out_path] do
          file = create_out_file!(opts[:out_path])
          Map.put(opts, :out_file, file)
        else
          opts
        end
        {:ok, opts}
      end
      defoverridable [init: 1]

      def handle_cast({:example_finished, example}, opts) do
        output = format_example(example, opts)
        write_output(output, opts[:out_file])
        {:noreply, opts}
      end

      def handle_cast({:final_result, examples, durations}, opts) do
        output = format_result(examples, durations, opts)
        write_output(output, opts[:out_file])
        if opts[:out_path], do: close_out_file(opts[:out_path])
        {:noreply, opts}
      end
      defoverridable [handle_cast: 2]
    end
  end
end
