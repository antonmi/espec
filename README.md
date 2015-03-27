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

Place your spec files into `spec` folder.

## Run specs

```sh
mix espec
```
Run specific spec:
```sh
mix espec spec/some_spec.exs:25
```

## Context blocks

TODO

## Exampes

TODO

## `before` and `finally`

TODO

## `let`, `let!`, and `subject`

TODO

## Matchers

TODO

## Mocks

TODO
