defmodule LetInSharedCacheSpec do
  use ESpec, shared: true, async: false

  let_overridable a: 10, b: 20
  let_overridable [:c, :d]
  let_overridable :e
  let_overridable :generated

  let :qqq, do: :qqq

  it "overrides a" do
    expect(a() |> to(eq 1))
  end

  it "leaves b as default" do
    expect(b() |> to(eq 20))
  end

  it "overrides c" do
    expect(c() |> to(eq 3))
  end

  it "checks d and e" do
    expect(d() |> to(eq nil))
    expect(e() |> to(eq nil))
  end

  it "does not change qqq" do
    expect(qqq() |> to(eq :qqq))
  end

  it "caches generated for 10 calls" do
    for _ <- 1..10, do: expect(generated() |> to(eq 0))
  end
end

defmodule UseLetSharedCacheSpec do
  use ESpec, async: true

  let :a, do: 1
  let :c, do: 3
  let :qqq, do: :www
  let :generated, do: LetGenerator.generate()

  finally do: LetGenerator.clean_generated()

  it_behaves_like(LetInSharedCacheSpec)
  include_examples(LetInSharedCacheSpec)

  it "caches generated for 10 calls" do
    for _ <- 1..10, do: expect(generated() |> to(eq 0))
  end
end

defmodule UseLetSharedAsKeywordCacheSpec do
  use ESpec

  finally do: LetGenerator.clean_generated(:generated_let_it_behaves_like)
  finally do: LetGenerator.clean_generated(:generated_let_include_examples)

  it_behaves_like(LetInSharedCacheSpec,
    a: 1,
    c: 3,
    qqq: :www,
    generated: LetGenerator.generate(:generated_let_it_behaves_like)
  )

  include_examples(LetInSharedCacheSpec,
    a: 1,
    c: 3,
    qqq: :www,
    generated: LetGenerator.generate(:generated_let_include_examples)
  )
end

defmodule LetGenerator do
  def generate(key \\ :generated_let_in_shared_spec) do
    generated = Application.get_env(:espec, key, 0)

    Application.put_env(:espec, key, generated + 1)

    generated
  end

  def clean_generated(key \\ :generated_let_in_shared_spec),
    do: Application.delete_env(:espec, key)
end
