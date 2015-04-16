defmodule CustomAssertions do

	def be_divisor_of(number), do: {BeDivisorOfAssertion, number}
	def be_odd, do: {BeOddAssertion, []}

end