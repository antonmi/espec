defmodule ESpecSpec do
  use ESpec, async: true

  it "sets @shared" do
    expect(@shared |> to(be false))
  end

  it "sets top level context" do
    expect(@context)
    |> to(
      eq [
        %ESpec.Context{description: "ESpecSpec", line: 2, module: ESpecSpec, opts: [async: true]}
      ]
    )
  end
end
