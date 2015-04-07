defmodule CustomAssertions do

	def be_divisor_of(number), do: {:be_divisor_of, number}
	def be_odd, do: {:be_odd, []}

	ESpec.register_assertions([
		be_divisor_of: BeDivisorOfAssertion,
		be_odd: BeOddAssertion
	])

end