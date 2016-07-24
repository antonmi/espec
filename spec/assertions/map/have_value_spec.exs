defmodule ESpec.Assertions.Map.HaveValueSpec do
  use ESpec, async: true

  subject %{a: 1, b: 2}

  context "Success" do
    it "checks success with `to`" do
      message = should have_value 1
      expect(message) |> to(eq "`%{a: 1, b: 2}` has value `1`.")
    end

    it "checks success with `not_to`" do
      message = should_not have_value 3
      expect(message) |> to(eq "`%{a: 1, b: 2}` doesn't have value `3`.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        { :shared,
          expectation: fn -> should have_value 3 end,
          message: "Expected `%{a: 1, b: 2}` to have value `3` but it doesn't have."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        { :shared,
          expectation: fn -> should_not have_value 1 end,
          message: "Expected `%{a: 1, b: 2}` not to have value `1` but it has."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
