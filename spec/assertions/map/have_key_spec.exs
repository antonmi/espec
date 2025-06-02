defmodule ESpec.Assertions.Map.HaveKeySpec do
  use ESpec, async: true

  subject %{a: 1}

  context "Success" do
    it "checks success with `to`" do
      message = should(have_key :a)
      expect(message) |> to(eq "`%{a: 1}` has key `:a`.")
    end

    it "checks success with `not_to`" do
      message = should_not(have_key :c)
      expect(message) |> to(eq "`%{a: 1}` doesn't have key `:c`.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        {:shared,
         expectation: fn -> should(have_key :c) end,
         message: "Expected `%{a: 1}` to have key `:c` but it doesn't have."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
         expectation: fn -> should_not(have_key :a) end,
         message: "Expected `%{a: 1}` not to have key `:a` but it has."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
