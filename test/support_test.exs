defmodule SupportTest do
  use ExUnit.Case, async: true

  test "random_string" do
    string = ESpec.Support.random_string()
    assert is_binary(string)
    assert String.length(string) > 20
  end

  test "word_chars" do
    string = ESpec.Support.word_chars("123  $@$#%$ ok")
    assert string == "___ok"
  end

  test "word_chars with unicode" do
    string = ESpec.Support.word_chars("áéíóúàèìòùäëïöü ok")
    assert string == "aeiouaeiouaeiou_ok"
  end
end
