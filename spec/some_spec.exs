defmodule SomeSpec do
  use ESpec
  
  # doctest ESpec.SomeModule
 #  before do
 #    tests = ExUnit.DocTest.__doctests__(ESpec.SomeModule,[])
  #   e1 = List.first(tests)
  #   e2 = List.last(tests)
  #   {:ok, e1: e1, e2: e2}
  # end

  # it do
  #   {name, q} = __.e1
  #   IO.inspect name
  #   IO.inspect q

  # end

  # it do
  #   {name, q} = __.e2
  #   IO.inspect name
  #   require IEx; IEx.pry
  #   IO.inspect Code.eval_quoted(q)
  # end

  # it do
  #   res = ESpec.DocTest.extract(ESpec.SomeModule)
  #   require IEx; IEx.pry
  # end

end
