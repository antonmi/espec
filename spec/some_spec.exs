# [{module, _ }] = Code.load_file("spec/support/some_module.ex")
# IO.inspect Code.ensure_compiled(module)

IO.inspect Kernel.ParallelCompiler.files(["spec/support/some_module.ex"])

defmodule SomeSpec do
  use ESpec

  it do 
    ESpec.SomeModule.f |> should eq(:f)
  end

  it do
    ESpec.SomeModule.m |> should eq(:m)
  end

  before do
    # allow(ESpec.SomeModule).to
  end


 
end 
