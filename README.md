# ESpec [![Build Status](https://travis-ci.org/antonmi/espec.svg?branch=master)](https://travis-ci.org/antonmi/espec)

ESpec is a BDD test framework for Elixir. Inspired by RSpec.

## Features

The main idea is to be close to the RSpec DSL.

  * Test organization with `describe`, `context`, `it`, and etc blocks
  * Familiar matchers: `eq`, `be_close_to`, `raise_execption`, etc
  * RSpec expectation syntax: `expect(smth1).to eq(smth2)` or `is_expected.to_not be_between(10, 20)`
  * `before` and `finally` blocks (like RSpec `before` and `after`)
  * `let`, `let!` and `subject`
  * Mocks with [Meck](https://github.com/eproxus/meck)

## Installation

Add `espec` to dependencies in the `mix.exs` file:

```elixir
def deps do
  ...
  {:espec, "~> 0.2.0", only: :test}
  ...
end
```
```sh
mix deps.get
```
Then run:
```sh
mix espec.init
```
The task creates `spec/spec_helper.exs` and `spec/example_spec.exs`.

Set `preferred_cli_env` for `espec` in the `mix.exs` file:

```elixir
def project do
  ...
  preferred_cli_env: [espec: :test]
  ...
end
```

Or run with `MIX_ENV=test`.

Place your `_spec.exs` files into `spec` folder. `use ESpec` in the 'spec module'.
```elixir
defmodule SomeSpec do
  use ESpec
  it do: expect(1+1).to eq(2)
end
```

## Run specs
```sh
mix espec
```
Run specific spec:
```sh
mix espec spec/some_spec.exs:25
```

## Context blocks
There are three macros with the same functionality: `context`, `describe`, and `example_group`.

Context can have description and options. 
```elixir
defmodule SomeSpec do
  use ESpec
  example_group do
    context "Some context" do
      it do: expect(true).to be true
    end
    describe "Some another context with opts", focus: true do
      it do: expect(1+1).to eq(2)
    end
  end
end
```
Available options are:
  * `skip: true` or `skip: "Reason"` - skips examples in the context;
  *  `focus: true` - sets focus to run with `--focus ` option.

There are also `xcontext`, `xdescribe`, `xexample_group` macros to skip example groups.
And `fcontext`, `fdescribe`, `fexample_group` for focused groups.

## Examples

`example`, `it`, and `specify` macros define the 'spec example'.
```elixir
defmodule SomeSpec do
  example do: expect(true).to be true
  it "Test with description" do
    expect(false).to_not be true
  end
  specify "Test with options", [pending: true], do: "pending"
end
```
You can use `skip`, `pending` or `focus` options to control evaluation.
There are also macros:
* `xit`, `xexample`, `xspecify` - to skip;
* `fit`, `fexample`, `fspecify`, `focus` - to focus;
* `pending/1`, `example/1`, `it/1`, `specify/1` - for pending examples.
```elixir
defmodule SomeSpec do
  use ESpec
  xit "skip", do: "skipped"
  focus "Focused", do: "Focused example"
  it "pending example"
  pending "it is also pending example"
end
```

## `before` and `finally`
`before` blocks are evaluated before the example and `finally` runs after the example.

The blocks can return `{:ok, key: value, ...}`, so the keyword list will be saved in the ditionary and can be accessed in other `before` blocks, in the example, and in `finaly` blocks through 'double-undescore' `__`:
```elixir
defmodule SomeSpec do
  use ESpec
  
  before do: {:ok, a: 1}
  
  context "Context" do
    before do: {:ok, b: __[:a] + 1}
    finally do: "#{__[:b]} == 2"
    
    it do: expect(__[:a]).to eq(1)
    it do: expect(__[:b]).to eq(2)
    
    finally do: "This finally will not be run. Define 'finally' before the example"
  end
end  
```
Note, that `finally` blocks must be defined before the example.

## 'Double-underscore'
`__` is used to share data between spec blocks. You can access data by `__.some_key` or `__[:some_key]`.
`__.some_key` will raise exception if the key 'some_key' does not exist, while `__[:some_key]` will return `nil`.

The `__` variable appears in your `before`, `finally`, `let` and `example` blocks.

`before` and `finally` blocks modify the dictionay when return `{:ok, key: value}`.

## `let`, `let!`, and `subject`
`let` and `let!` have the same behaviour as in RSpec. Both defines memoizable functions in 'spec module'.
`let` evaluates when accessing the function while `let!` called in 'before' chain.
The `__` is available in 'lets' but neither `let` nor `let!` can modify the dictionary.
```elixir
defmodule SomeSpec do
  use ESpec
  
  before do: {:ok, a: 1}
  let! :a, do: __.a
  let :b, do: __.a + 1
  
  it do: expect(a).to eq(1)
  it do: expect(b).to eq(2)
end  
```
`subject` is just an alias for `let(:subject)`. You can use `is_expected` macro when `subject is defined.
```elixir
defmodule SomeSpec do
  use ESpec
  
  subject(1+1)
  it do: is_expected.to eq(2)

  context "with block" do
    subject do: 2+2
    it do: is_expected.to eq(4)
  end
end 
```

## Matchers
#### Equality
```elixir
expect(actual).to eq(expected)  # passes if actual == expected
expect(actual).to eql(expected) # passes if actual === expected
```
#### Comparisons
Can be used with `:>`, `:<`, `:>=`, `:<=`, and etc. 
```elixir
expect(actual).to be operator, value 
```
Passes if `apply(Kernel, operator, [actual, value]) == true`
#### Regular expressions
```elixir
expect(actual).to match(~r/expression/)
expect(actual).to match("string")
```
#### Exceptions
```elixir
expect(function).to raise_exception
expect(function).to raise_exception(ErrorModule)
expect(function).to raise_exception(ErrorModule, "message")
```
#### Throws
```elixir
expect(function).to throw_term
expect(function).to throw_term(term)
```
#### Change state
Test if call of function1 change the function2 returned value to smth or from to smth
```elexir
expect(function1).to change(function2, to)
expect(function1).to change(function2, from, to) 
```

## Mocks
ESpec uses [Meck](https://github.com/eproxus/meck) to mock functions.
You can mock the module with 'allow accept':
```elixir
defmodule SomeSpec do
  use ESpec
  before do: allow(SomeModule).to accept(:func, fn(a,b) -> a+b end)
  it do: expect(SomeModule.func(1, 2)).to eq(3)
end
```
Note, when you mock some function in module, `meck` creates an absolutely new module.

You can also pass a list of atom-function pairs to the `accept` function:
```elixir
allow(SomeModule).to accept(f1: fn -> :f1 end, f2: fn -> :f2 end)
```
There is also an expectation to check if the module accepted a function call:
```elixir
defmodule SomeSpec do
  use ESpec
  before do: allow(SomeModule).to accept(:func, fn(a,b) -> a+b end)
  before do: SomeModule.func(1, 2)
  it do: expect(SomeModule).to accepted(:func, [1,2])
end
```
`expect(SomeModule).to accepted(:func, [1,2])` just checks `meck.history(SomeModule)`.

## Configuration
TODO







