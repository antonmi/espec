defmodule ESpec.Assertions.BeOkResultSpec do
  use ESpec, async: true

  describe "ESpec.Assertions" do
    let :ok_result, do: {:ok, :result}
    let :error_result, do: {:error, :reason}

    context "Success" do
      it "checks success with `to`" do
        message = expect(ok_result) |> to(be_ok_result)
        expect(message) |> to(eq "`{:ok, :result}` is a success result.")
      end

      it "checks success with `not_to`" do
        message = expect(error_result) |> not_to(be_ok_result)
        expect(message) |> to(eq "`{:error, :reason}` isn't a success result.")
      end
    end

    context "Errors" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect(error_result) |> to(be_ok_result) end,
            message: "Expected `{:error, :reason}` to be a success result but it is not."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect(ok_result) |> not_to(be_ok_result) end,
            message: "Expected `{:ok, :result}` not to be a success result but it is."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
