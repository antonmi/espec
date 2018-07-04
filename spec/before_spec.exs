defmodule BeforeSpec do
  use ESpec, async: true

  before do
    {:ok, a: "top before"}
  end

  it do: expect shared.a |> to(eq "top before")
  it do: expect shared[:b] |> to(eq nil)
  it do: expect shared[:c] |> to(eq nil)

  describe "D1" do
    before do: {:shared, b: "D1 before"}

    it do: expect shared.a |> to(eq "top before")
    it do: expect shared.b |> to(eq "D1 before")
    it do: expect shared[:c] |> to(eq nil)

    describe "D2" do
      before do: {:ok, c: "D2 before"}

      it do: expect shared.a |> to(eq "top before")
      it do: expect shared.b |> to(eq "D1 before")
      it do: expect shared.c |> to(eq "D2 before")
    end

    describe "With map" do
      before do: {:shared, %{a: 1, b: 2}}

      it do: expect shared.a |> to(eq 1)
      it do: expect shared.b |> to(eq 2)
    end

    describe "With keyword" do
      before a: 1, b: 2
      before c: shared[:b] + 1

      it do: expect shared.a |> to(eq 1)
      it do: expect shared.b |> to(eq 2)
      it do: expect shared.c |> to(eq 3)
    end

    describe "Not valid" do
      before do: {:shared, [%{a: 1, b: 2}]}

      it do: expect shared.a |> to(eq "top before")
      it do: expect shared.b |> to(eq "D1 before")
    end

    describe "Ignore if map is not enumerable" do
      before do: {:ok, %ESpec.Before{}}

      it do: expect shared.a |> to(eq "top before")
    end
  end

  context "function in 'shared'" do
    before do: {:ok, a: fn a -> a * 2 end}

    it do: expect shared.a.(5) |> to(eq 10)
    it do: expect shared[:b] |> to(be_nil())
    it do: expect shared[:c] |> to(be_nil())
  end

  context "before block does not return :ok" do
    before do: :smth
    it do: expect shared.a |> to(eq "top before")
  end

  context "'shared' is available in next befores" do
    before do: {:ok, a: 1}
    before do: {:ok, b: shared[:a] + 1}
    it do: expect shared.b |> to(eq 2)
  end

  context "many before blocks" do
    before do: {:ok, a: "a"}
    before do: {:shared, a: "aa", b: "b"}
    before do: {:ok, %{a: "aaa", b: "bbb", c: "ccc"}}

    it do: expect shared.a |> to(eq "aaa")
    it do: expect shared.b |> to(eq "bbb")
    it do: expect shared.c |> to(eq "ccc")
  end
end
