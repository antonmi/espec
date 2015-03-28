defmodule ConfigurationTest do

	use ExUnit.Case

	setup_all do
		opts = [a: 1, b: 2]
		ESpec.Configuration.add(opts)
		{:ok, opts}
	end

	test "check configurations", context do
		assert(ESpec.Configuration.get(:a) == context[:a])
		assert(ESpec.Configuration.get(:b) == context[:b])
	end

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

