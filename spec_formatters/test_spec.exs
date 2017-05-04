Code.require_file("spec_formatters/custom_formatter.ex")
Code.require_file("spec_formatters/spec_helper.exs")

defmodule TestSpec do
  use ESpec, async: true

  it "just simple test" do
    expect(1+1).to eq(2)
  end

  context "with context" do
    it "another test" do
      assert true
    end

    xit "skips" do
      assert false
    end
  end
end
