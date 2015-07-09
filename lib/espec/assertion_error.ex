defmodule ESpec.AssertionError do
  @moduledoc """
  Defines ESpec.AssertionError exception.
  The exception is raised by `ESpec.Assertions.Interface.raise_error/4` when example fails.
  """
  defexception subject: nil, data: nil, result: nil, asserion: nil, message: nil
end
