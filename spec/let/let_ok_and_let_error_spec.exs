defmodule LetOkAndLetErrorSpec do
  use ESpec, async: true

  def ok_fun, do: {:ok, 10}
  def error_fun, do: {:error, 20}

  describe "let_ok" do
    let_ok :ok_result, do: ok_fun()
    let_ok! :ok_result!, do: ok_fun()

    it do: expect(ok_result()).to(eq(10))
    it do: expect(ok_result!()).to(eq(10))

    context "let_ok is lazy" do
      let_ok :ok_result do
        Application.put_env(:espec, :let_ok, "let_ok")
      end

      it "does not put env" do
        value = Application.get_env(:espec, :let_ok)
        expect(value |> to(eq nil))
      end
    end

    context "let_ok! is not lazy" do
      let_ok! :ok_result do
        Application.put_env(:espec, :let_ok!, "let_ok!")
        {:ok, 1}
      end

      it "does not put env" do
        value = Application.get_env(:espec, :let_ok!)
        expect(value |> to(eq "let_ok!"))
      end
    end
  end

  describe "let_error" do
    let_error :error_result, do: error_fun()
    let_error! :error_result!, do: error_fun()

    it do: expect(error_result()).to(eq(20))
    it do: expect(error_result!()).to(eq(20))

    context "let_error is lazy" do
      let_ok :let_error do
        Application.put_env(:espec, :let_error, "let_error")
      end

      it "does not put env" do
        value = Application.get_env(:espec, :let_error)
        expect(value |> to(eq nil))
      end
    end

    context "let_error! is not lazy" do
      let_ok! :let_error do
        Application.put_env(:espec, :let_error!, "let_error!")
        {:ok, 1}
      end

      it "does not put env" do
        value = Application.get_env(:espec, :let_error!)
        expect(value |> to(eq "let_error!"))
      end
    end
  end
end
