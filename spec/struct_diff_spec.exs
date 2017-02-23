defmodule StructDiffSpec do
  use ESpec

  alias ESpec.StructDiff

  describe "#diff" do
    subject do: StructDiff.diff(a, b)

    context "for lists" do
      let :a, do: [:a, :b, :c, :d, :e]

      context "with different element-count" do
        let :b, do: [:a, :b, :c]

        it do: should eq %{:!= => b}
      end

      context "with differing elements" do
        let :b, do: [:a, :b, :b, :d, :e]

        it do: should eq %{[2] => %{:!= => :b}}
      end

      context "with many edits" do
        let :b, do: [:b, :a, :d, :c, :e]

        it do: should eq %{:!= => b}
      end
    end

    context "for maps" do
      let :a, do: %{a: 1, b: 2, c: 3}

      context "with additional keys" do
        let :b, do: %{a: 1, b: 2, c: 3, d: 4}

        it do: should eq %{:+ => [:d]}
      end

      context "with missing keys" do
        let :b, do: %{a: 1, c: 3}

        it do: should eq %{:- => [:b]}
      end

      context "with differing values" do
        let :b, do: %{a: 1, b: 3, c: 3}

        it do: should eq %{[:b] => %{:!= => 3}}
      end

      context "with lots of changes" do
        let :b, do: %{a: 2, c: 2, d: 4}

        it do: should eq %{:!= => b}
      end

      context "for nested diffs" do
        let :a, do: %{a: 1, b: [1, 2, 3], c: 3}

        context "with single change" do
          let :b, do: %{a: 1, b: [1, 3, 3], c: 3}

          it do: should eq %{[:b,1] => %{:!= => 3}}
        end

        context "with multiples change" do
          let :b, do: %{a: 1, b: [2, 3, 3], c: 3}

          it do: should eq %{
            [:b] => %{
              [0] => %{:!= => 2},
              [1] => %{:!= => 3},
            },
          }
        end
      end
    end

    context "for complex example" do
      let :a, do: %{
        users: ["richmond", "kate", "stephen"],
        counter: 5,
        rooms: %{
          alpha: %{free: 3},
          beta: %{free: 2},
        },
      }
      let :b, do: %{
        users: ["richmond", "kate", "julie"],
        counter: 2,
        rooms: %{
          alpha: %{free: 3},
          beta: %{free: 5},
        },
      }

      it do: should eq %{
        [:users, 2]            => %{:!= => "julie"},
        [:counter]             => %{:!= => 2},
        [:rooms, :beta, :free] => %{:!= => 5},
      }
    end
  end

  describe "#format" do
    subject do: StructDiff.format(diffmap, prefix)
    let :prefix, do: ""

    context "for noop" do
      let :diffmap, do: %{}

      it do: should eq "Values completely match\n"
    end

    context "for extra items" do
      let :diffmap, do: %{:+ => [:a, :b]}

      it do: should eq "has extra: `[:a, :b]`\n"
    end

    context "for missing items" do
      let :diffmap, do: %{:- => [:a, :b]}

      it do: should eq "missing: `[:a, :b]`\n"
    end

    context "for mismatch" do
      let :diffmap, do: %{:!= => :b}

      it do: should eq "got: `:b`\n"
    end

    context "for complex example" do
      let :diffmap, do: %{
        [:users, 2]            => %{:!= => "julie"},
        [:counter]             => %{:!= => 2},
        [:rooms, :beta, :free] => %{:!= => 5},
      }
      let :prefix, do: "## "

      it do: should eq "## at [:counter]:
##   got: `2`
## at [:rooms][:beta][:free]:
##   got: `5`
## at [:users][2]:
##   got: `\"julie\"`
"
    end
  end

  describe "#format_diff" do
    subject do: StructDiff.format_diff(a, b, prefix)
    let :prefix, do: "## "
    let :a, do: %{
      users: ["richmond", "kate", "stephen"],
      counter: 5,
      rooms: %{
        alpha: %{free: 3},
        beta: %{free: 2},
      },
    }
    let :b, do: %{
      users: ["richmond", "kate", "julie"],
      counter: 2,
      rooms: %{
        alpha: %{free: 3},
        beta: %{free: 5},
      },
    }

    it do: should eq "## at [:counter]:
##   got: `2`
## at [:rooms][:beta][:free]:
##   got: `5`
## at [:users][2]:
##   got: `\"julie\"`
"
  end
end
