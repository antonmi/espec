defmodule ESpec.Mock do

	def expect(module, name, function) do
		try do
			:meck.new(module, [:non_strict])
		rescue
			error -> :ok #TODO already started
		end
		:meck.expect(module, name, function)
	end
end