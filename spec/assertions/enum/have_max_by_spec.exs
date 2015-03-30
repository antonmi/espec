defmodule ESpec.Assertions.Enum.HaveMaxBySpec do

  use ESpec

  let :range, do: (1..3)
  let :func, do: fn(el) -> 10 / el end

  context "Success" do
    it do: expect(range).to have_max_by(func, 1)
    it do: expect(range).to_not have_max_by(func, 3)
  end

  xcontext "Error" do
    it do: expect(range).to_not have_max_by(func, 1)
    it do: expect(range).to have_max_by(func, 2)
  end

end