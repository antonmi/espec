defmodule LetWithKeywordSpec do
  use ESpec, async: true

  describe "let" do
    let a: 1, b: 2
    let x: :z

    it do: expect a() |> to(eq 1)
    it do: expect b() |> to(eq 2)
    it do: expect x() |> to(eq :z)

    context "when overrided" do
      let b: 3, c: 4

      it do: expect b() |> to(eq 3)
      it do: expect c() |> to(eq 4)
    end
  end

  describe "let!" do
    let! a: 1, b: 2
    let x: :z

    it do: expect a() |> to(eq 1)
    it do: expect b() |> to(eq 2)
    it do: expect x() |> to(eq :z)

    context "when overrided" do
      let! b: 3, c: 4

      it do: expect b() |> to(eq 3)
      it do: expect c() |> to(eq 4)
    end

    context "forces evaluation before examples" do
      let! [
        test1: Application.put_env(:espec, :letbang_value_test1, "test1"),
        test2: Application.put_env(:espec, :letbang_value_test2, "test2")
      ]


      it "has run before example" do
        expect Application.get_env(:espec, :letbang_value_test1) |> to(eq "test1")
      end

      it "has run before example" do
        expect Application.get_env(:espec, :letbang_value_test2) |> to(eq "test2")
      end
    end

    context "when overridden, is used by before" do
      let! test: "initial"

      before do
        expect test() |> to(eq "overridden")
      end

      context "some context" do
        let! test: "overridden"

        it "equals 131" do
          expect test() |> to(eq "overridden")
        end
      end
    end

    context "when overridden, is used by other let! declarations, even in parent contexts" do
      let! test: 123
      let! test2: test() + 1

      context "some context" do
        let! test: 130

        it "equals 131" do
          expect test2() |> to(eq 131)
        end
      end
    end
  end
end
