defmodule LetInGeneratedExamples do
  use ESpec

  context "using let in nested contexts" do
    Enum.each [:a, :b, :c], fn(value) ->
      context "with value #{inspect value}" do
        let :x, do: unquote(value)

        it "should equal #{inspect value}" do
          x() |> should(eq unquote(value))
        end
      end
    end
  end

  context "using subject in nested contexts" do
    Enum.each [:a, :b, :c], fn(value) ->
      context "with value #{inspect value}" do
        subject(unquote(value))

        it "should equal #{inspect value}" do
          should(eq unquote(value))
          should(eq unquote(value))
        end
      end
    end
  end
end