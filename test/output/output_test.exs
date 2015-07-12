defmodule OutputTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    it do: expect(1).to eq(1)
  end

  setup_all do
    # path = "tmp/output"
    # File.mkdir_p!(Path.dirname(path))
    # {:ok, file} = File.open(path, [:write])
    # ESpec.Configuration.add([out: path])
    # ESpec.Configuration.add([out_file: file])
    
    # ESpec.Configuration.add([silent: false])

    # ESpec.Runner.start
    
    {:ok, []}
    # {:ok,
      # examples: ESpec.Runner.run_examples(SomeSpec.examples)
    # }
  end


  test "run ex1", context do
    # IO.inspect "1111111"
    # IO.inspect ESpec.Configuration.get(:out)
    # examples = ESpec.Runner.run_examples(SomeSpec.examples)
    # ESpec.Output.print_result(examples)
    # IO.inspect "1111111"
    # IO.inspect ESpec.Configuration.get(:out)
    # # text =  ExUnit.CaptureIO.capture_io(fn ->
    # # end)
    # IO.inspect "----"
  end

end
