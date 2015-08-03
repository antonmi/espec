defmodule CaptureIOSpec do
  use ESpec

  it "tests capture_io/1" do
    capture_io(fn -> IO.write "john" end) |> should eq "john"
  end

  it "tests capture_io/2" do
    fun = fn ->
      input = IO.gets ">"
      IO.write input
    end  
    capture_io("this is input", fun) |> should eq ">this is input"
  end
end
