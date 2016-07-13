defmodule ESpec.Assertions.Enum.HaveMinSpec do
  use ESpec, async: true

  let :range, do: (1..3)

  context "Success" do
    it "checks success with `to`" do
      message = expect(range).to have_min(1)
      expect(message) |> to(eq "The minimum value of `1..3` is `1`.")
    end

    it "checks success with `not_to`" do
      message = expect(range).to_not have_min(2)
      expect(message) |> to(eq "The minimum value of `1..3` is not `2`.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        { :shared,
          expectation: fn -> expect(range).to have_min(2) end,
          message: "Expected the minimum value of `1..3` to be `2` but the minimum is `1`."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        { :shared,
          expectation: fn -> expect(range).to_not have_min(1) end,
          message: "Expected the minimum value of `1..3` not to be `1` but the minimum is `1`."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
