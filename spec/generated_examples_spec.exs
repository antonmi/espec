defmodule GeneratedExamplesSpec do
  use ESpec, async: true

  subject 1..5

  Enum.map 1..3, fn(n) ->
    it do: is_expected().to have(unquote(n))
  end

  context "with description" do
    subject(24)

    Enum.map 2..4, fn(n) ->
      it "is divisible by #{n}" do
        expect(rem(subject(), unquote(n))).to be(0)
      end
    end
  end
end
