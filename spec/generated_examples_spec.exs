defmodule GeneratedExamplesSpec do
  use ESpec, async: true

  subject 1..5

  Enum.map(1..3, fn n ->
    it do: is_expected() |> to(have unquote(n))
  end)

  context "with description" do
    subject(24)

    Enum.map(2..4, fn n ->
      it "is divisible by #{n}" do
        expect(rem(subject(), unquote(n)) |> to(be 0))
      end
    end)
  end

  context "using a module attribute instead of unquote()" do
    subject(%{a: 1, b: 2, c: 3})

    Enum.each([:a, :b, :c], fn key ->
      @key key
      it "it has key #{key}" do
        is_expected() |> to(have_key(@key))
      end
    end)
  end

  context "with description and shared data" do
    subject([:c])
    before do: {:shared, list: [:a, :b]}

    Enum.each([:a, :b, :c], fn value ->
      @value value
      it "it + shared has value #{@value}" do
        expect(subject() ++ shared.list) |> to(have(@value))
      end
    end)
  end
end
