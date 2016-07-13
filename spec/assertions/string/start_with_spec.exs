defmodule ESpec.Assertions.String.StartWithSpec do
  use ESpec, async: true

  subject "qwerty"

  context "Success" do
    it "checks success with `to`" do
      message = should start_with "qwe"
      expect(message) |> to(eq "`\"qwerty\"` starts with `\"qwe\"`.")
    end

    it "checks success with `not_to`" do
      message = should_not start_with "ert"
      expect(message) |> to(eq "`\"qwerty\"` doesn't start with `\"ert\"`.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        { :shared,
          expectation: fn -> should start_with "ert" end,
          message: "Expected `\"qwerty\"` to start with `ert` but it starts with `qwe...`."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        { :shared,
          expectation: fn -> should_not start_with "qwe" end,
          message: "Expected `\"qwerty\"` not to start with `qwe` but it starts with `qwe`."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end

  context "Short string" do
    subject "q"

    context "Success" do
      it "checks success with `to`" do
        message = should start_with "q"
        expect(message) |> to(eq "`\"q\"` starts with `\"q\"`.")
      end

      it "checks success with `not_to`" do
        message = should_not start_with "ert"
        expect(message) |> to(eq "`\"q\"` doesn't start with `\"ert\"`.")
      end
    end

    context "Error" do
      context "with `to`" do
        before do
          { :shared,
            expectation: fn -> should start_with "e" end,
            message: "Expected `\"q\"` to start with `e` but it starts with `q...`."
          }
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          { :shared,
            expectation: fn -> should_not start_with "q" end,
            message: "Expected `\"q\"` not to start with `q` but it starts with `q`."
          }
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
