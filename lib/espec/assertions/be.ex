defmodule ESpec.Assertions.Be do

  @behaviour ESpec.Assertion
  use ESpec.Assertion

  defp match(subject, [op, val]) do
    result = apply(Kernel, op, [subject, val])
    {result, result}
  end

  defp error_message(subject, [op, val], result, positive) do
    "Expected `#{inspect subject} #{op} #{inspect val}` to be `#{positive}` but got `#{!positive}`."
  end

end
