defmodule ESpec.Mock do

	def expect(module, name, function) do
		:meck.new(module, [:non_strict])
		:meck.expect(module, name, function)
	end
end