defmodule DiffSpec do
  use ESpec, async: true

  defmacrop diff_1_2 do
    if Version.match?(System.version(), "< 1.15.0") do
      quote do
        %ExUnit.Diff{
          equivalent?: false,
          left: {:__block__, [], [{:__block__, [diff: true], ["2"]}]},
          right: {:__block__, [], [{:__block__, [diff: true], ["1"]}]}
        }
      end
    else
      quote do
        %ExUnit.Diff{
          equivalent?: false,
          left: %{delimiter: nil, contents: [true: "2"]},
          right: %{delimiter: nil, contents: [true: "1"]}
        }
      end
    end
  end

  defmacrop diff_1_1 do
    quote do
      %ExUnit.Diff{equivalent?: true, left: 1, right: 1}
    end
  end

  describe ".diff" do
    it "when there is a diff" do
      expect(ESpec.Diff.diff(1, 2) |> to(eq(diff_1_2())))
    end

    it "when there is no diff" do
      expect(ESpec.Diff.diff(1, 1) |> to(eq(diff_1_1())))
    end
  end
end
