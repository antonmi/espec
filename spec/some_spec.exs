defmodule SomeSpec do
  use ESpec

  before do: {:ok, answer: __.answer + 1}          # __ == %{anwser: 43}       
  finally do: {:ok, answer: __.answer + 1}             # __ == %{anwser: 46} 

  context do
    before do: {:ok, answer: __.answer + 1}        # __ == %{anwser: 43} 
    finally do: {:ok, answer: __.answer + 1}           # __ == %{anwser: 45} 
    it do: __.answer |> should eq 44
  end
end 
