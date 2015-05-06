

defmodule Mod1 do
  
  defmacro mac1(do: block) do
    quote do
      unquote(block)
    end
  end  
end

defmodule Mod2 do
  
  defmacro mac2(arg) do
    quote do
      Enum.each(1..3, fn(el) -> 
        a = "aaaa"
        mac1 do
          IO.inspect el
          IO.inspect a
        end
      end)
    end
  end  

end

defmodule Used do

  defmacro __using__(args) do
    quote do
      import Mod1
      import Mod2
    end
  end
end

defmodule ESpec.SomeModule do
  use Used

  # mac2 :mac2
  
  @doc """
    iex> 1 + 1
    2

    iex> 2 + 2
    5
  """
  def f, do: f
    
end


