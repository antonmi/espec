defmodule ESpec.Assertions.Enum.HaveMinBySpec do
  use ESpec, async: true

  let :range, do: (1..3)
  let :func, do: fn(el) -> 10 / el end

  context "Success" do
    it do: expect(range).to have_min_by(func, 3)
    it do: expect(range).to_not have_min_by(func, 1)
  end

  xcontext "Error" do
    it do: expect(range).to_not have_min_by(func, 3)
    it do: expect(range).to have_min_by(func, 1)
  end
end
