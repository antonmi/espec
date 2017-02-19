defmodule ESpec.Output.Common do
  defmacro __using__(_opts) do
    quote  do
      use GenEvent

      def init(opts) do
        opts = if opts[:out_path] do
          file = create_out_file!(opts[:out_path])
          Map.put(opts, :out_file, file)
        else
          opts
        end
        {:ok, opts}
      end

      def handle_event({:example_info, example}, opts) do
        output = format_example(example, opts)
        write_output(output, opts[:out_file])
        {:ok, opts}
      end

      def format_example(example, opts), do: ""
      defoverridable [format_example: 2]

      def handle_event({:print_result, examples, durations}, opts) do
        output = format_result(examples, durations, opts)
        write_output(output, opts[:out_file])
        if opts[:out_path], do: close_out_file(opts[:out_path])
        {:ok, opts}
      end

      def format_result(examples, durations, _opts), do: ""
      defoverridable [format_result: 3]

      defp write_output(output, file) do
        if file do
          IO.write(file, output)
        else
          IO.write(output)
        end
      end

      defp create_out_file!(path) do
        File.mkdir_p!(Path.dirname(path))
        {:ok, file} = File.open(path, [:write])
        file
      end

      defp close_out_file(path) do
        File.close(path)
      end
    end
  end
end
