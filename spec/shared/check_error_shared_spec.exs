defmodule CheckErrorSharedSpec do
  use ESpec, shared: true

  it "checks error" do
    try do
      shared[:expectation].()
    rescue
      error in [ESpec.AssertionError] ->
        expect(error.message) |> to(eq shared[:message])

        case shared[:extra] do
          nil -> :ok
          true -> expect(error.extra) |> to_not(be_nil())
          false -> expect(error.extra) |> to(be_nil())
          value -> expect(error.extra) |> to(eq value)
        end
    end
  end
end
