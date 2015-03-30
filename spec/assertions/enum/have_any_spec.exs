defmodule ESpec.Assertions.Enum.HaveAnySpec do

  use ESpec

  let :range, do: (1..3)

  let :positive, do: fn(el) -> el == 2 end
  let :negative, do: fn(el) -> el < 0 end
  
  context "Success" do
    it do: expect(range).to have_any(positive)
    it do: expect(range).to_not have_any(negative)
  end

  xcontext "Error" do
    it do: expect(range).to_not have_any(positive)
    it do: expect(range).to have_any(negative)
  end

end
