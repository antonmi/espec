defmodule SomeSpec do
  use ESpec
  before do: {:ok, a: 1}
  context "Context" do
    before do: {:ok, b: __[:a] + 1}
    finally do
     	IO.puts "#{__[:b]} == 2"
     	{:ok, a: 10}
    end 
    finally do: IO.puts "#{__[:a]}"
    it do: expect(__.a).to eq(1)
    it do: expect(__.b).to eq(2)
  end
end 