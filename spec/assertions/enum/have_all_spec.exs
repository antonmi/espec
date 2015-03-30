defmodule ESpec.Assertions.Enum.HaveAllSpec do

  use ESpec

  let :range, do: (1..3)
  let :list, do: [1,2,3]
  let :dict, do: %{a: 1, b: 2, c: 3}

  let :positive, do: fn(el) -> el > 0 end
  let :negative, do: fn(el) -> el < 0 end
  
  context "Success" do
    it do: expect(range).to have_all(positive)
    it do: expect(list).to have_all(positive)
    it do: expect(dict).to have_all(positive)

    it do: expect(range).to_not have_all(negative)
  end

  context "Error" do
    it do: expect(range).to_not have_all(positive)
    it do: expect(range).to have_all(negative)
  end

end
