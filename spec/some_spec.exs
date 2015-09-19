defmodule SomeSpec do
  use ESpec

  context "Tag1", tag1: true do
    it "it_tag", it_tag: "it_tag" do
      expect(1).to eq(1)
    end
  end
end
