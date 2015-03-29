defmodule SkippedSpec do

	use ESpec

	it "skipped", skip: true do
		:skipped
	end

	it [skip: "Some reason"], do: :skipped

	context "Skipped", skip: "Context Reason" do
		it [skip: "Contex reason has preference"], do: :skipped
	end
end