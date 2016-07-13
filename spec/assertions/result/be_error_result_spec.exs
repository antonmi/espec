defmodule ESpec.Assertions.BeErrorResultSpec do
  use ESpec, async: true

  describe "ESpec.Assertions" do
    let :error_result, do: {:error, :reason}
    let :ok_result, do: {:ok, :result}

    context "Success" do
      it "checks success with `to`" do
        message = expect(error_result) |> to(be_error_result)
        expect(message) |> to(eq "`{:error, :reason}` is a error result.")
      end

      it "checks success with `not_to`" do
        message = expect(ok_result) |> not_to(be_error_result)
        expect(message) |> to(eq "`{:ok, :result}` isn't a error result.")
      end
    end

    context "Errors" do
      context "with `to`" do
        before do
          { :shared,
            expectation: fn -> expect(ok_result) |> to(be_error_result) end,
            message: "Expected `{:ok, :result}` to be a error result but it is not."
          }
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          { :shared,
            expectation: fn -> expect(error_result) |> not_to(be_error_result) end,
            message: "Expected `{:error, :reason}` not to be a error result but it is."
          }
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
