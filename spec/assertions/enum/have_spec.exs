defmodule ESpec.Assertions.Enum.HaveSpec do
  use ESpec, async: true

  let :range, do: 1..3
  let :list, do: [{}]

  context "Success" do
    it "checks success with `to`" do
      message = expect(range()).to(have(2))
      expect(message) |> to(eq "`1..3` has `2`.")
    end

    it "checks success with `to`" do
      message = expect(list()).to(have({}))
      expect(message) |> to(eq "`[{}]` has `{}`.")
    end

    it "checks success with `not_to`" do
      message = expect(range()).to_not(have(4))
      expect(message) |> to(eq "`1..3` doesn't have `4`.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        {:shared,
         expectation: fn -> expect(range()).to(have(4)) end,
         message: "Expected `1..3` to have `4`, but it has not."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
         expectation: fn -> expect(range()).to_not(have(2)) end,
         message: "Expected `1..3` not to have `2`, but it has."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
         expectation: fn -> expect(list()).to_not(have({})) end,
         message: "Expected `[{}]` not to have `{}`, but it has."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
