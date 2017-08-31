defmodule LetSpec do
  use ESpec, async: true

  describe "let!" do
    let!(:f) do
      fn(x) -> x * 2 end
    end

    it do: expect(f().(2)).to eq(4)

    context "redefine" do
      let! :f, do: 5
      it do: expect(f()).to eq(5)
    end

    context "use 'shared''" do
      before do: {:ok, a: 1}
      let! :a, do: shared[:a] + 1
      it do: expect(a()).to eq(2)
    end

    context "forces evaluation before examples" do
      let! :test do
        Application.put_env(:espec, :letbang_value, "let!")
        456
      end

      it "has run before example" do
        value = Application.get_env(:espec, :letbang_value, "")
        expect value |> to(eq "let!")
        expect test() |> to(eq 456)
      end
    end

    context "only runs once per example", async: false do
      defp get_value do
        value = Application.get_env(:espec, :letbang_value_once, "initial call")

        Application.put_env(:espec, :letbang_value_once, "subsequent calls")

        value
      end

      finally do: Application.delete_env(:espec, :letbang_value_once)

      context "as `let! :value, do: get_value()`" do
        let! :value, do: get_value()

        it do: expect value() |> to(eq "initial call")
      end

      context "as `let! value: get_value()`" do
        let! value: get_value()

        it do: expect value() |> to(eq "initial call")
      end
    end

    context "when overridden, is used by before" do
      let! :test, do: "initial"

      before do
        expect test() |> to(eq "overridden")
      end

      context "some context" do
        let! :test, do: "overridden"

        it "equals 131" do
          expect test() |> to(eq "overridden")
        end
      end
    end

    context "when overridden, is used by other let! declarations, even in parent contexts" do
      let! :test, do: 123
      let! :test2, do: test() + 1

      context "some context" do
        let! :test, do: 130

        it "equals 131" do
          expect test2() |> to(eq 131)
        end
      end
    end
  end

  describe "let" do
    let(:f) do
      fn(x) -> x * 2 end
    end

    it do: expect(f().(2)).to eq(4)

    context "redefine" do
      let :f, do: 5
      it do: expect(f()).to eq(5)
    end

    context "use 'shared'" do
      before do: {:ok, a: 1}
      let :a, do: shared[:a] + 1
      it do: expect(a()).to eq(2)
    end
  end

  describe "let use let" do
    let :a, do: 1
    let :b, do: a() + 1

    it do: b() |> should(eq 2)
  end

  describe "let is lazy and memorizes" do
    let :a do
      value = Application.get_env(:espec, :let_value, "") <> ".let"
      Application.put_env(:espec, :let_value, value)
      value
    end

    it do
      Application.put_env(:espec, :let_value, "initial")
      expect(a()).to eq("initial.let")
      expect(a()).to eq("initial.let")
    end
  end

  describe "let_ok extracts the value from an {:ok, result}" do
    let_ok :a, do: {:ok, 1}
    let_ok! :b, do: {:ok, 2}
    let_ok c: {:ok, 3}
    let_ok d: {:ok, 4}

    it do: a() |> should(eq 1)
    it do: b() |> should(eq 2)
    it do: c() |> should(eq 3)
    it do: d() |> should(eq 4)
  end

  describe "let_error extracts the value from an {:error, result}" do
    let_error :a, do: {:error, 1}
    let_error! :b, do: {:error, 2}
    let_error c: {:error, 3}
    let_error d: {:error, 4}

    it do: a() |> should(eq 1)
    it do: b() |> should(eq 2)
    it do: c() |> should(eq 3)
    it do: d() |> should(eq 4)
  end
end
