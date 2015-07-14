defmodule ESpec.Assertions.Enum.HaveCountBySpec do
  use ESpec, async: true

  let :range, do: (1..3)
  let :func, do: fn(el) -> el > 1 end
  
  context "Success" do
    it do: expect(range).to have_count_by(func, 2)
    it do: expect(range).to_not have_count_by(func, 3)
  end

  xcontext "Error" do
    it do: expect(range).to_not have_count_by(func, 2)
    it do: expect(range).to have_count_by(func, 3)
  end
end
