defmodule DiffSpec do
  use ESpec, async: true

  describe ".diff" do
    it "when diff is" do
      expect(ESpec.Diff.diff(1, 2)).to eq({[ins: "1"], [del: "2"]})
    end

    it "when no diff" do
      expect(ESpec.Diff.diff(1, 1)).to eq({[eq: "1"], [eq: "1"]})
    end
  end

  describe ".diff_with_aligned_eq" do
    it "when diff is" do
      expected = {[eq: "[", ins: "1", ins: ", ", ins: "2", eq: "]"], [eq: "[", del: "2", ins_whitespace: 3, eq: "]"]}
      expect(ESpec.Diff.diff_with_aligned_eq([1,2], [2])).to eq(expected)
    end

    it "when no diff" do
      expect(ESpec.Diff.diff_with_aligned_eq([1,2], [1,2])).to eq({[eq: "[1, 2]"], [eq: "[1, 2]"]})
    end
  end
end
