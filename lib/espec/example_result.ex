defmodule ESpec.ExampleResult do

  defstruct example: %ESpec.Example{}, success: nil, error: %ESpec.AssertionError{}

  def success(results) do
    results |> Enum.filter(&(&1.success))
  end

  def failed(results) do
    results |> Enum.filter(&(!&1.success))
  end
end
