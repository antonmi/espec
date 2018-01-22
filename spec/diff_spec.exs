defmodule DiffSpec do
  use ESpec, async: true

  describe ".diff" do
    it "when diff is" do
      expect(ESpec.Diff.diff(1, 2)).to(eq({[ins: "1"], [del: "2"]}))
    end

    it "when no diff" do
      expect(ESpec.Diff.diff(1, 1)).to(eq({[eq: "1"], [eq: "1"]}))
    end
  end
end
