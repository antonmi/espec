defmodule ConfigurationTest do

	use ExUnit.Case

	test "configure function" do
		ESpec.configure(fn(c) ->
			c.hello :world
		end)
		assert(ESpec.Configuration.get(:hello) == :world)
	end

	test "allows only whitelistet functions" do
		assert_raise(UndefinedFunctionError, fn ->
			ESpec.configure(fn(c) -> c.hey :world end)
		end)
	end

end

