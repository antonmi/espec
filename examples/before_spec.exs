defmodule BeforEspec do

  use Espec

  before do
    IO.puts "top before"
  end

  it do: IO.puts "Top it"

  describe "D1" do
    before do
      IO.puts "D1 before"
    end

    it do:  IO.puts "D1 it"

    describe "D2" do
      before do
        IO.puts "D2 before"
      end

      it do: IO.puts "D2 it"
    end

  end


end

# IO.puts(inspect BeforEspec.examples)

BeforEspec.run
