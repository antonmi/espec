# ESpec [![Build Status](https://travis-ci.org/antonmi/espec.svg?branch=master)](https://travis-ci.org/antonmi/espec)

ESpec is a BDD test framework for Elixir.
Inspired by RSpec. Take a look at the [spec](https://github.com/antonmi/espec/tree/master/spec) folder.

## Features

The main idea is to be close to the RSpec phylosophy.

  * Test organization with `describe`, `context`, `it`, and etc blocks
  * Familiar matchers: `eq`, `be_close_to`, `raise_execption`, etc
  * RSpec expectation syntax: `expect(smth1).to eq(smth2)` or `is_expected.to_not be_between(10, 20)`
  * `before` and `finally` blocks (like RSpec `before` and `after`)
  * `let`, `let!` and `subject`
  * Mocks and stubs. (uses [Meck](https://github.com/eproxus/meck))

## Installation

Add `espec` to dependencies in the `mix.exs` file:

```elixir
def deps do
  ...
  {:espec, "~> 0.2.0", only: :test}
  ...
end
```

Set `preferred_cli_env` for `espec` in the `mix.exs` file:

```elixir
def project do
  ...
  preferred_cli_env: [espec: :test]
  ...
end
```

Or run with `MIX_ENV=test`.

Create a spec folder and add `spec_helper.exs` with `ESpec.start`.

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
      it do: "example"
    end
    describe "Some another context with opts", focus: true do
     it do: "example"
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

`example`, `it`, and `specify` macros define the spec example.
```elixir
defmodule SomeSpec do
  example do: expect(true).to be true
  it "Test with description" do
    expect(false).to_not be true
  end
  specify "Test with options", [pending: true], do: "pending"
end
```


## `before` and `finally`

TODO

## `let`, `let!`, and `subject`

TODO

## Matchers

TODO

## Mocks

TODO
