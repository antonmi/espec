defmodule LetInSharedWithSpec do
  use ESpec, shared: true, async: true

  let_overridable a: 10, b: 20
  let_overridable [:c, :d]
  let_overridable :e

  let :qqq, do: :qqq

  it "overrides a" do
    expect(a()).to(eq(1))
  end

  it "leaves b as default" do
    expect(b()).to(eq(20))
  end

  it "overrides c" do
    expect(c()).to(eq(3))
  end

  it "checks d and e" do
    expect(d()).to(eq(nil))
    expect(e()).to(eq(nil))
  end

  it "does not change qqq" do
    expect(qqq()).to(eq(:qqq))
  end
end

defmodule UseLetSharedSpecSpec do
  use ESpec

  let :a, do: 1
  let :c, do: 3
  let :qqq, do: :www

  it_behaves_like(LetInSharedWithSpec)
  include_examples(LetInSharedWithSpec)
end

defmodule UseLetSharedAsKeywordSpecSpec do
  use ESpec

  it_behaves_like(LetInSharedWithSpec, a: 1, c: 3, qqq: :www)
  include_examples(LetInSharedWithSpec, a: 1, c: 3, qqq: :www)
end
