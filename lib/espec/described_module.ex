defmodule ESpec.DescribedModule do
  @moduledoc """
  Defines the 'described_module' helper which makes accessing tested module possible.
  Keep in mind the convention 'module TheModuleSpec is spec for TheModule'
  """

  defmacro __using__(_arg) do
    quote do
      module = Atom.to_string(__MODULE__) |> String.split(~r/Spec$/) |> hd |> String.to_atom
      Module.put_attribute __MODULE__, :described_module, module

      def described_module, do: @described_module
    end
  end
end
