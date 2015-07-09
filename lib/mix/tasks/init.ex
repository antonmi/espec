defmodule Mix.Tasks.Espec.Init do
	use Mix.Task
	import Mix.Generator

	@shortdoc "Create spec/spec_helper.exs and spec/example_spec.exs"

	@spec_folder "spec"
	@spec_helper "spec_helper.exs"
	@example_spec "example_spec.exs"

	def run(_args) do
		create_directory @spec_folder
		create_file(Path.join(@spec_folder, @spec_helper), spec_helper_template(nil))
		create_file(Path.join(@spec_folder, @example_spec), example_spec_template(nil))
	end

	embed_template :spec_helper, """
	ESpec.start
		
	ESpec.configure fn(config) ->
		config.before fn ->
			{:ok, hello: :world}
		end
		
		config.finally fn(__) -> 
			__.hello
		end
	end
	"""

	embed_template :example_spec, """
	defmodule ExampleSpec do
		
		use ESpec
		
		before do
			answer = Enum.reduce((1..9), &(&2 + &1)) - 3
			{:ok, answer: answer} #saves {:key, :value} to `__`
		end

		example "test" do
			expect(__.answer).to eq(42)
		end

		context "Defines context" do
			subject(__.answer)
			
			it do: is_expected.to be_between(41, 43)
			
			describe "is an alias for context" do
				before do
					value = __.answer * 2
					{:ok, new_answer: value}
				end

				let :val, do: __.new_answer

				it "checks val" do
					expect(val).to eq(84)
				end  
			end
		end

		xcontext "xcontext skips examples." do
			xit "And xit also skips" do
				"skipped"
			end
		end

		pending "There are so many features to test!"
	end 
	"""
end
