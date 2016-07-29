defmodule ESpec.Assertions.Binary.HaveByteSizeSpec do
  use ESpec, async: true

  let :byte_count, do: byte_size(binary)
  let :binary, do: <<116, 188, 252, 155, 9>>

  context "Success" do
    it "checks success with `to`" do
      message = expect(binary).to have_byte_size(byte_count)
      expect(message) |> to(eq "`<<116, 188, 252, 155, 9>>` has `#{byte_count}` byte(s).")
    end

    it "checks success with `not_to`" do
      message = expect(binary).to_not have_byte_size(byte_count - 1)
      expect(message) |> to(eq "`<<116, 188, 252, 155, 9>>` doesn't have `#{byte_count - 1}` byte(s).")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        { :shared,
          expectation: fn -> expect(binary).to have_byte_size(byte_count - 1) end,
          message: "Expected `<<116, 188, 252, 155, 9>>` to have `#{byte_count - 1}` byte(s) but it has `#{byte_count}`."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        { :shared,
          expectation: fn -> expect(binary).to_not have_byte_size(byte_count) end,
          message: "Expected `<<116, 188, 252, 155, 9>>` not to have `#{byte_count}` byte(s) but it has `#{byte_count}`."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
