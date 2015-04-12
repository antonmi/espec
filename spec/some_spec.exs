defmodule SomeSpec do
  use ESpec
  
	before do
	  allow(ESpec.SomeModule).to accept(:func, fn(a,b) -> a+b end)
	  ESpec.SomeModule.func(1, 2)
	end  
 
 	it do: expect(ESpec.SomeModule).to accepted(:func, [1,2])

 	describe "with options" do
		defmodule Server do
			def call(a, b) do
				ESpec.SomeModule.func(a, b)
				ESpec.SomeModule.func(a, b)
			end
		end

		before do
			pid = spawn(Server, :call, [1, 2])
			:timer.sleep(100)
			{:ok, pid: pid}
		end

  	it do: expect(ESpec.SomeModule).to accepted(:func, [1,2], pid: __.pid, count: 2)
	end
end
