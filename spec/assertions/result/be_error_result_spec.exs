defmodule ESpec.Assertions.BeErrorResultSpec do
  use ESpec, async: true

  describe "ESpec.Assertions" do
    let :error_result, do: {:error, :reason}
    let :ok_result, do: {:ok, :result}

    context "Success" do
      it do: expect error_result |> to(be_error_result)
      it do: expect ok_result |> not_to(be_error_result)
    end

    xcontext "Errors" do
      it do: expect error_result |> not_to(be_error_result)
      it do: expect ok_result |> to(be_error_result)
    end
  end
end
