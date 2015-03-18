defmodule SomEspec do
  use Espec

  describe "d1" do
    it "some_spec_1" do
      IO.puts("it")
    end

    describe "d1_1" do

      it "some_spec_1" do
        IO.puts("it")
      end

      describe "d1_2" do

      end

    end

  end

  describe "d2" do
    describe "d2_1" do

    end
  end

  describe "d3" do

  end
end
