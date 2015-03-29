defmodule ExampleSpec do
  
  use ESpec
  
  it "test" do
    allow(ESpec.SomeModule).to accept(:f, fn(a, b) -> a + b end)
    ESpec.SomeModule.f(1, 2)
    # ESpec.SomeModule.f(2)
    # ESpec.SomeModule.f(3)
    expect(ESpec.SomeModule).to accepted(:f, [1, 2])
  end
end 