defmodule ESpec.Assertions.BeOkResultSpec do
  use ESpec, async: true

  describe "ESpec.Assertions" do
    let :ok_result, do: {:ok, :result}
    let :error_result, do: {:error, :reason}

    context "Success" do
      it do: expect ok_result |> to(be_ok_result)
      it do: expect error_result |> not_to(be_ok_result)
    end

    xcontext "Errors" do
      it do: expect ok_result |> not_to(be_ok_result)
      it do: expect error_result |> to(be_ok_result)
    end
  end
end
