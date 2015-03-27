# ESpec

[![Build Status](https://travis-ci.org/antonmi/espec.svg?branch=master)](https://travis-ci.org/antonmi/espec)
=====

ESpec BDD test framework for Elixir.
Inspired by RSpec.

## Features
-----------
The main idea is to be close to RSpec.

  * Test organization with `describe`, `context`, `it`, and etc blocks
  * Expectation syntax: `expect(smth1).to eq(smth2)` or `is_expected.to be_between(10, 20)`
  * `before` and `finally` blocks (like RSpec `before` and `after`)
  * `let`, `let!` and `subject`
  * Mocks and stubs. (uses [Meck](https://github.com/eproxus/meck)
  * 

## Installation


Take a look at [spec](https://github.com/antonmi/espec/tree/master/spec) folder.
