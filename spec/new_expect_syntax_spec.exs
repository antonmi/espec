defmodule NewExpectSyntax do
  use ESpec

  context "simple specs" do
    it do: expect(1 |> to(eq 1))
    it do: expect(1 |> to_not(eq 2))
    it do: expect(1 |> not_to(eq 2))

    context "with subject" do
      subject 1
      it do: is_expected() |> to(eq 1)
      it do: is_expected() |> to_not(eq 2)
      it do: is_expected() |> not_to(eq 2)
    end
  end

  context "more comlex specs" do
    subject %{a: 1, b: 2}
    it do: expect(subject() |> to(have_key :a))
    it do: expect(subject() |> to_not(have_key :c))
    it do: is_expected() |> to(have_key :a)
    it do: is_expected() |> to_not(have_key :c)
  end
end
