defmodule PendingExampleTest do

  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec

    it do: "Example"
    
    it "with focus", [focus: true], do: "focus true"
    focus "with focus", do: "focus focus"
    fit "pending with message", do: "focus fit"
    fexample "pending with message", do: "focus fexample"
    fspecify "pending with message", do: "focus fspecify"
    
    fcontext "focus context" do
      it do: "focus fcontext"
    end
  end

  setup_all do
    ESpec.Configuration.add([focus: true])
    examples = ESpec.Runner.run
    {:ok,
      ex1: Enum.at(examples, 0),
      ex2: Enum.at(examples, 1),
      ex3: Enum.at(examples, 2),
      ex4: Enum.at(examples, 3),
      ex5: Enum.at(examples, 4),
      ex6: Enum.at(examples, 5),
    }
  end

  test "ex1", context do    
    assert(context[:ex1].result == "focus true")
  end

  test "ex2", context do    
    assert(context[:ex2].result == "focus focus")
  end

  test "ex3", context do    
    assert(context[:ex3].result == "focus fit")
  end

  test "ex4", context do    
    assert(context[:ex4].result == "focus fexample")
  end

  test "ex5", context do    
    assert(context[:ex5].result == "focus fspecify")
  end

  test "ex6", context do    
    assert(context[:ex6].result == "focus fcontext")
  end


 
end