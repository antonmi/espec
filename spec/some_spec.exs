defmodule SomeSpec do
  use ESpec
  
  before do
    ex1 = %{context: ["S1"], it: "it"}
    ex2 = %{context: ["S1", "S1C1"], it: :it}
    ex3 = %{context: ["S1", "S1C1"], it: :it}
    ex4 = %{context: ["S1", "S1C1", "S1C2"], it: :it}
    ex5 = %{context: ["S1", "S1C1", "S1C2"], it: :it}
    ex6 = %{context: ["S1", "S1C3"], it: :it}
    ex7 = %{context: ["S2"], it: :it}
    ex8 = %{context: ["S2", "S2C1"], it: :it}
    ex9 = %{context: ["S2", "S2C1", "S2C2"], it: :it}
    ex10 = %{context: ["S2", "S2C3"], it: :it}
    exs = [ex1, ex2, ex3, ex4, ex5, ex6, ex7, ex8, ex9, ex10]
    {:ok,
      ex1: ex1, ex2: ex2, ex3: ex3, ex4: ex4, ex5: ex5,
      ex6: ex6, ex7: ex7, ex8: ex8, ex9: ex9, ex10: ex10,
      exs: exs,
    }
  end

  let :result do
    %{
      "S1" => %{
                exs: [__.ex1],
                ctxs: %{
                        "S1C1" => %{
                                    exs: [__.ex2, __.ex3],
                                    ctxs: %{
                                            "S1C2" => %{
                                                        exs: [__.ex4, __.ex5],
                                                        ctxs: %{}
                                                      }
                                         }
                                  },
                        "S1C3" => %{
                                    exs: [__.ex6],
                                    ctxs: %{}
                                  }
                      }
              },
      "S2" => %{
                exs: [__.ex7],
                ctxs: %{
                        "S2C1" => %{
                                    exs: [__.ex8],
                                    ctxs: %{
                                            "S2C2" => %{
                                                        exs: [__.ex9],
                                                        ctxs: %{}
                                                      }
                                          }
                                  },
                        "S2C3" => %{
                                    exs: [__.ex10],
                                    ctxs: %{}
                                  }
                      }
              }
    }
  end

  let :height do
    longest = Enum.max_by(__.exs, fn(ex) ->
      Enum.count(ex[:context])
    end)
    Enum.count(longest[:context])
  end

  it do: expect(height).to eq(3)

  it do: IO.inspect result






end
