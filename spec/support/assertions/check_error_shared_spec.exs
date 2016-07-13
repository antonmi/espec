defmodule CheckErrorSharedSpec do
  use ESpec, shared: true

  it "checks error" do
    try do
      shared[:expectation].()
    rescue
      error in [ESpec.AssertionError] -> expect(error.message) |> to(eq shared[:message])
    end
  end
end
