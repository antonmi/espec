defmodule ESpec.Assertions.Map.HaveSpec do
  use ESpec, async: true

  defmodule TestStruct do
    defstruct [:foo]
  end

  let map: %{foo: "bar"}
  let struct: %TestStruct{foo: "bar"}

  context "Success" do
    it "checks success with `to` for map" do
      message = expect(map()).to have({:foo, "bar"})
      expect(message) |> to(eq "`%{foo: \"bar\"}` has `{:foo, \"bar\"}`.")
    end

    it "checks success with `to` for struct" do
      message = expect(struct()).to have({:foo, "bar"})
      expect(message) |> to(eq "`%ESpec.Assertions.Map.HaveSpec.TestStruct{foo: \"bar\"}` has `{:foo, \"bar\"}`.")
    end

    it "checks success with `to` for map with single element Keyword list" do
      message = expect(map()).to have(foo: "bar")
      expect(message) |> to(eq "`%{foo: \"bar\"}` has `[foo: \"bar\"]`.")
    end

    it "checks success with `to` for struct with single element Keyword list" do
      message = expect(struct()).to have(foo: "bar")
      expect(message) |> to(eq "`%ESpec.Assertions.Map.HaveSpec.TestStruct{foo: \"bar\"}` has `[foo: \"bar\"]`.")
    end

    it "checks success with `not_to`" do
      message = expect(map()).to_not have(4)
      expect(message) |> to(eq "`%{foo: \"bar\"}` doesn't have `4`.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        {:shared,
         expectation: fn -> expect(map()).to have(4) end,
         message: "Expected `%{foo: \"bar\"}` to have `4`, but it has not."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
         expectation: fn -> expect(map()).to_not have({:foo, "bar"}) end,
         message: "Expected `%{foo: \"bar\"}` not to have `{:foo, \"bar\"}`, but it has."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
         expectation: fn -> expect(struct()).to_not have({:foo, "bar"}) end,
         message: "Expected `%ESpec.Assertions.Map.HaveSpec.TestStruct{foo: \"bar\"}` not to have `{:foo, \"bar\"}`, but it has."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
