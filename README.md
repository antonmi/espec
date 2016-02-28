# ESpec
[![Build Status](https://travis-ci.org/antonmi/espec.svg?branch=master)](https://travis-ci.org/antonmi/espec)
[![Hex.pm](https://img.shields.io/hexpm/v/espec.svg?style=flat-square)](https://hex.pm/packages/espec)

##### ESpec is a BDD testing framework for Elixir.

It is NOT a wrapper around ExUnit but a completely new testing framework written from scratch.

ESpec is inspired by RSpec and the main idea is to be close to its perfect DSL.

## Features
  * Test organization with `describe`, `context`, `it`, and etc blocks.
  * Familiar matchers: `eq`, `be_close_to`, `raise_exception`, etc.
  * Possibility to add custom matchers.
  * There are three (!) types of expectation syntax:
    - RSpec syntax with `expect` helper: `expect(smth1).to eq(smth2)` or `is_expected.to eq(smth)` when `subject` is defined;
    - `expect` syntax with pipe operator `expect smth1 |> to(eq smth2)` or `is_expected |> to(eq smth)` when `subject` is defined;
    - `should` syntax: `smth1 |> should(eq smth2)` or `should eq smth` when `subject` is defined.
  * `before` and `finally` blocks (like RSpec `before` and `after`).
  * `let`, `let!` and `subject`.
  * Shared examples.
  * Async examples.
  * Mocks with Meck.
  * Doc specs.
  * HTML and JSON outputs.
  * Etc and etc.

## Contents
- [Installation](#installation)
- [Run specs](#run-specs)
- [Context blocks](#context-blocks)
- [Examples](#examples)
- [Filters](#filters)
- ['before' and 'finally'](#before-and-finally)
- ['shared' data](#shared-data)
- ['let' and 'subject'](#let-and-subject)
- [Shared examples](#shared-examples)
- [Async examples](#async-examples)
- [Matchers](#matchers)
- [Custom matchers](#custom-matchers)
- [Mocks](#mocks)
- [Doc specs](#doc-specs)
- [Configuration and options](#configuration-and-options)
- [Contributing](#contributing)

## Installation

Add `espec` to dependencies in the `mix.exs` file:

```elixir
def deps do
  ...
  {:espec, "~> 0.8.15", only: :test},
  #{:espec, github: "antonmi/espec", only: :test}, to get the latest version
  ...
end
```
```sh
mix deps.get
```
Then run:
```sh
MIX_ENV=test mix espec.init
```
The task creates `spec/spec_helper.exs` and `spec/example_spec.exs`.

Set `preferred_cli_env` for `espec` in the `mix.exs` file:

```elixir
def project do
  ...
  preferred_cli_env: [espec: :test],
  ...
end
```

Or run with `MIX_ENV=test`:
```sh
MIX_ENV=test mix espec
```

Place your `_spec.exs` files into `spec` folder. `use ESpec` in the 'spec module'.
```elixir
defmodule SomeSpec do
  use ESpec
  it do: expect true |> to(be_true)
  it do: expect(1+1).to eq(2)
  it do: (1..3) |> should(have 2)
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

Read the help:
```sh
MIX_ENV=test mix help espec
```

## Context blocks
There are three macros with the same functionality: `context`, `describe`, and `example_group`.

Context can have description and options.
```elixir
defmodule SomeSpec do
  use ESpec

  example_group do
    context "Some context" do
      it do: expect "abc" |> to(match ~r/b/)
    end

    describe "Some another context with opts", focus: true do
      it do: 5 |> should(be_between 4, 6)
    end
  end
end
```
Available options are:
  * `skip: true` or `skip: "Reason"` - skips examples in the context;
  *  `focus: true` - sets focus to run with `--focus ` option.

There are also `xcontext`, `xdescribe`, `xexample_group` macros to skip example groups.
And `fcontext`, `fdescribe`, `fexample_group` for focused groups.

'spec' module is also a context with module name as description. One can add options for this context after `use ESpec:`
```elixir
defmodule SomeSpec do
  use ESpec, skip: "Skip all examples in the module"
  ...
end
```
## Examples

`example`, `it`, and `specify` macros define the 'spec example'.
```elixir
defmodule SomeSpec do

  example do: expect [1,2,3] |> to(have_max 3)

  it "Test with description" do
    4.2 |> should(be_close_to 4, 0.5)
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

##Filters
The are `--only`, `--exclude` and `--string` command line options.

One can tag example or context and then use `--only` or `--exclude` option to run (or exclude) tests with specific tag.
```elixir
defmodule SomeSpec do
  use ESpec

  context "context with tag", context_tag: :some_tag do
    it do: "some example"
    it "example with tag", example_tag: true do
     "another example"
    end
  end
end
```
```sh
mix espec spec/some_spec.exs --only context_tag:some_tag --exclude example_tag
```
This runs only one test "some example"

You can also filter examples by `--string` option which filter examples which contain given string it their nested description.
```sh
mix espec spec/some_spec.exs --string 'context with tag'
```

## `before` and `finally`
`before` blocks are evaluated before the example and `finally` runs after the example.

The blocks can return `{:shared, key: value, ...}` or (like in ExUnit) `{:ok, key: value, ...}`, so the keyword list will be saved in the dictionary and can be accessed in other `before` blocks, in the example, and in `finally` blocks through ['shared`](#shared):
```elixir
defmodule SomeSpec do
  use ESpec

  before do: {:shared, a: 1}

  context "Context" do
    before do: {:shared, b: shared[:a] + 1}
    finally do: "#{shared[:b]} == 2"

    it do: shared.a |> should(eq 1)
    it do: shared.b |> should(eq 2)

    finally do: "This finally will not be run. Define 'finally' before the example"
  end
end  
```
Note, that `finally` blocks must be defined before the example.
You can configure 'global' `before` and `finally` in `spec_helper.exs`:
```elixir
ESpec.start

ESpec.configure fn(config) ->
  config.before fn -> {:shared, answer: 42} end  #can assign values in dictionary
  config.finally fn(shared) -> shared.answer  end     #can access assigns
end
```
These functions will be called before and after each example which ESpec runs.

## 'shared' data
`shared` is used to share data between spec blocks. You can access data by `shared.some_key` or `shared[:some_key]`.
`shared.some_key` will raise exception if the key 'some_key' does not exist, while `shared[:some_key]` will return `nil`.

The `shared` variable appears in your `before`, `finally`, in `config.before` and `config.finally`, in `let` and `example` blocks.

`before` and `finally` blocks (including 'global') can modify the dictionay when return `{:shared, key: value}`.
The example bellow illustrate the life-cycle of `shared`:

`spec_helper.exs`
```elixir
ESpec.start

ESpec.configure fn(config) ->
  config.before fn -> {:shared, answer: 42} end         # shared == %{anwser: 42}
  config.finally fn(shared) -> IO.puts shared.answer  end    # it will print 46   
end
```
`some_spec.exs`:
```elixir
defmodule SomeSpec do
  use ESpec

  before do: {:shared, answer: shared.answer + 1}          # shared == %{anwser: 43}       
  finally do: {:shared, answer: shared.answer + 1}         # shared == %{anwser: 46}

  context do
    before do: {:shared, answer: shared.answer + 1}        # shared == %{anwser: 44}
    finally do: {:shared, answer: shared.answer + 1}       # shared == %{anwser: 45}
    it do: shared.answer |> should(eq 44)
  end
end
```
So, 'config.finally' will print `46`.
Pay attention to how `finally` blocks are defined and evaluated.

## `let` and `subject`
`let` and `let!` have the same behaviour as in RSpec. Both defines memoizable functions in 'spec module'. The value will be cached across multiple calls in the same example but not across examples. `let` is not evaluated until the first time the function it defines is invoked. Use `let!` to force the  invocation before each example.

The `shared` is available in 'lets' but neither `let` nor `let!` can modify the dictionary.
```elixir
defmodule SomeSpec do
  use ESpec

  before do: {:shared, a: 1}
  let! :a, do: shared.a
  let :b, do: shared.a + 1

  it do: expect a |> to(eq 1)
  it do: expect b |> to(eq 2)
end  
```
`subject` and `subject!` are just aliases for `let :subject, do: smth` and `let! :subject, do: smth`. You can use `is_expected` macro (or a simple `should` expression) when `subject` is defined.
```elixir
defmodule SomeSpec do
  use ESpec

  subject(1+1)
  it do: is_expected |> to(eq 2)
  it do: should eq 2

  context "with block" do
    subject do: 2+2
    it do: is_expected |> to_not(eq 2)
    it do: should_not eq 2
  end
end
```
## Shared Examples
One can reuse the examples defined in spec module.
```elixir
defmodule SharedSpec do
  use ESpec, shared: true

  subject shared.hello
  it do: should eq("world!")
end
```
`shared: true` marks examples in the module as shared, so the examples will be skipped until you reuse them.
You can use the examples with `it_behaves_like` or its alias `include_examples` macro:
```elixir
defmodule UseSharedSpec do
  use ESpec

  before do: {:ok, hello: "world!"}
  it_behaves_like(SharedSpec)
  #or
  include_examples(SharedSpec)
end
```
Be carefull with `let` and `let!` when using shared examples. You can't access `let` from 'spec module' in 'shared module'.
```elixir
defmodule SomeSharedSpec do
  use ESpec, shared: true
  it do: expect a |> to(eq "a")
end

defmodule SomeSpec do
  use ESpec
  let :a, do: "a"
  include_examples(SomeSharedSpec)
end
```
Elixir will not compile `SomeSharedSpec` module with error: function a/0 undefined. So use `shared` dictionary in 'before' block to set the value.

## Async examples
There is an `async: true` option you can set for the context or for the individual example:
```elixir
defmodule AsyncSpec do
  use ESpec, async: true
  it do: "async example"

  context "Sync", async: false do
    it do: "sync example"

    it "async again", async: true do
      "async"
    end
  end
end
```
The examples will be partitioned into two queries. Examples in asynchronous query will be executed in parallel in different processes.

Don't use `async: true` if you change the global state in your specs!

## Matchers
#### Equality
```elixir
expect actual |> to(eq expected)  # passes if actual == expected
expect actual |> to(eql expected) # passes if actual === expected
expect actual |> to(be_close_to expected, delta)
expect actual |> to(be_between hard_place, rock)
```
#### Comparisons
Can be used with `:>`, `:<`, `:>=`, `:<=`, and etc.
```elixir
expect actual |> to(be operator, value)
```
Passes if `apply(Kernel, operator, [actual, value]) == true`
#### Booleans
```elixir
expect actual |> to(be_true)
expect actual |> to(be_truthy)
expect actual |> to(be_false)
expect actual |> to(be_falsy)
```
#### Regular expressions
```elixir
expect actual |> to(match ~r/expression/)
expect actual |> to(match "string")
```
#### Enumerable
There are many helpers to test enumerable collections:
```elixir
expect collection |> to(be_empty) #Enum.count(collection) == 0
... have value                   #Enum.member?(collection, value)
... have_all func                #Enum.all?(collection, func)
... have_any func                #Enum.any?(collection, func)
... have_at position, value      #Enum.at?(collection, position) == value
... have_count value             #Enum.count(collection) == value
... have_size value              #alias
... have_length value            #alias
... have_count_by func, value    #Enum.count(collection, func) == value
... have_max value               #Enum.max(collection) == value
... have_max_by func, value      #Enum.max_by(collection, fun) == value
... have_min value               #Enum.min(collection) == value
... have_min_by func, value      #Enum.min_by(collection, fun) == value
```
#### List
```elixir
expect list |> to(have_first value)  #List.first(list) == value
... have_last value                 #List.last(list) == value
... have_hd value                   #hd(list) == value
... have_tl value                   #tl(list) == value
```
#### String
```elixir
expect string |> to(have_first value)  #String.first(string) == value
... have_last value                   #String.last(string) == value
... start_with value                  #String.starts_with?(string, value)
... end_with value                    #String.end_with?(string, value)
... have value                        #String.contains?(string, value)    
... have_at pos, value                #String.at(string, pos) == value
... have_length value                 #Stirng.length(string) == value
... have_size value                   #alias
... have_count value                  #alias
... be_valid_string                   #String.valid?(string)
... be_printable                      #String.printable?(string)
```
#### Dict
```elixir
expect dict |> to(have_key value)    #Dict.has_key?(value)
expect dict |> to(have_value value)  #Enum.member?(Dict.values(dict), value)
```

#### Type checking
``` elixir
expect :espec |> to(be_atom)  #is_atom(:espec) == true
... be_binary
... be_bitstring
... be_boolean
... ...
... ...
... be_tuple
... be_function
... be_function arity
... be_struct
... be_struct StructExample
```
#### Exceptions
```elixir
expect function |> to(raise_exception)
expect function |> to(raise_exception ErrorModule)
expect function |> to(raise_exception ErrorModule, "message")
```
#### Throws
```elixir
expect function |> to(throw_term)
expect function |> to(throw_term term)
```
#### Change state
Test if call of function1 change the function2 returned value to smth or from to smth
```elixir
expect function1 |> to(change function2, to)
expect function1 |> to(change function2, from, to)
```
#### Check result
Test if function returns `{:ok, result}` or `{:error, reason}` tuple
```elixir
expect {:ok, :the_result} |> to(be_ok_result)
expect {:error, :an_error} |> to(be_error_result)
```


## Custom matchers
You can define your own matchers!
The only functions you should implement is `match/2`, `success_message/4`, and `error_message`.
Read the [wiki page](https://github.com/antonmi/espec/wiki/Custom-matchers) for detailed instructions.
There is an example [custom_assertion_spec.exs](https://github.com/antonmi/espec/blob/master/spec/assertions/custom_assertion_spec.ex).

## Mocks
ESpec uses [Meck](https://github.com/eproxus/meck) to mock functions.
You can mock the module with 'allow accept':
```elixir
defmodule SomeSpec do
  use ESpec
  context "with old syntax"
    before do: allow(SomeModule).to accept(:func, fn(a,b) -> a+b end)
    it do: expect SomeModule.func(1, 2) |> to(eq 3)
  end

  context "with new syntax"
    before do: allow SomeModule |> to(accept :func, fn(a,b) -> a+b end)
    it do: expect SomeModule.func(1, 2) |> to(eq 3)
  end
end
```
If you don't specify the function to return ESpec creates stubs with arity `0` and `1`:
`fn -> end` and `fn(_) -> end`, which return `nil`.
```elixir
defmodule SomeSpec do
  use ESpec
  before do: allow SomeModule |> to(accept :func)
  it do: expect SomeModule.func |> to(be_nil)
  it do: expect SomeModule.func(42) |> to(be_nil)
end
```
Behind the scenes 'allow accept' makes the following:
```elixir
:meck.new(module, [:non_strict, :passthrough])
:meck.expect(module, name, function)
```
Find the explanation aboute the `:non_strict` and `:passthrough` options [here](https://github.com/eproxus/meck/blob/master/src/meck.erl).
The default options (`[:non_strict, :passthrough]`) can be overridden:
```elixir
allow SomeModule) |> to(accept :func, fn(a,b) -> a+b end, [:non_strict, :unstick])
```
All the mocked modules are unloaded whith `:meck.unload(modules)` after each example.

You can also pass a list of atom-function pairs to the `accept` function:
```elixir
allow SomeModule |> to(accept f1: fn -> :f1 end, f2: fn -> :f2 end)
```
One can use `passthrough/1` function to call the original function:
```elixir
  before do
    allow SomeModule |> to(accept(:fun, fn
      :mocked -> "mock!"
      _ -> passthrough([args])
    end))
  end

  it do: expect SomeModule.fun(:mocked) |> to(eq "mock!")
  it do: expect SomeModule.fun(2) |> to(eq 3)
```
The `passthrough/1` just calls the `:meck.passthrough/1` from the `:meck` module.

There is also an expectation to check if the module accepted a function call:
```elixir
accepted(func, args \\ :any, opts \\ [pid: :any, count: :any])
```
So, the options are:
- test if the function is called with some particular arguments of with `any`;
- specify the `pid` of the process which called the function;
- test the count of function calls.

```elixir
defmodule SomeSpec do
  use ESpec
  before do
    allow SomeModule |> to(accept :func, fn(a,b) -> a+b end)
    SomeModule.func(1, 2)
  end  

  it do: expect SomeModule |> to(accepted :func)
  it do: expect SomeModule |> to(accepted :func, [1,2])

  describe "with options" do
    defmodule Server do
      def call(a, b) do
        ESpec.SomeModule.func(a, b)
        ESpec.SomeModule.func(a, b)
      end
    end

    before do
      pid = spawn(Server, :call, [1, 2])
      :timer.sleep(100)
      {:ok, pid: pid}
    end

    it do: expect ESpec.SomeModule |> to(accepted :func, [1,2], pid: shared.pid, count: 2)
  end
end
```
`accepted` assertion checks `:meck.history(SomeModule)`. See [meck](https://github.com/eproxus/meck) documentation.

Don't use `async: true` when using mocks!

## Doc specs
ESpec has functionality similar to [`ExUnit.DocTest`](http://elixir-lang.org/docs/stable/ex_unit/).
Read more about docs syntax [here](http://elixir-lang.org/docs/stable/ex_unit/)
The functionality is implemented by two modules:
`ESpec.DocExample` parses module documentation and `ESpec.DocTest` creates 'spec' examples for it.
`ESpec.DocExample` functions is just copy-paste of `ExUnit.Doctest` parsing functionality.
`ESpec.DocTest` implement `doctest` macro which identical to `ExUnit` analogue.
```elixir
defmodule SomeSpec do
  use ESpec
  doctest MySuperModule
end  
```
There are three options (similar to `ExUnit.DocTest`):

`:except` - generate specs for all functions except those listed (list of {function, arity} tuples).
```elixir
defmodule SomeSpec do
  use ESpec
  doctest MySuperModule, except: [fun: 1, func: 2]
end  
```
`:only` — generate specs only for functions listed (list of {function, arity} tuples).

And `:import` to test a function defined in the module without referring to the module name.Default is `false`. Use this option with care because you can clash with another modules.

There are three types of specs can be generated based on docs.

- Examples where input and output can be evaluated. For example:
```elixir
@doc """
iex> Enum.map [1, 2, 3], fn(x) ->
...>   x * 2
...> end
[2,4,6]
"""
```  
Such examples will be converted to:
```elixir
it "Example description" do
  expect input |> to(eq output)
end  
```
- Examples which return complex structure so Elixir prints it as `#Name<...>.`:
```elixir
@doc """
iex> Enum.into([a: 10, b: 20], HashDict.new)
#HashDict<[b: 20, a: 10]>
"""
```
The examples will be converted to:
```elixir
it "Example description" do
  expect inspect(input) |> to(eq output)
end
```
- Examples with exceptions:
```elixir
@doc """
iex(1)> String.to_atom((fn() -> 1 end).())
** (ArgumentError) argument error
"""
```
The examples will be tested as:
```elixir
it "Example description" do
  expect fn -> input end |> to(raise_exception error_module, error_message)
end
```

## Configuration and options
```sh
`MIX_ENV=test mix help espec`
```
#### Spec paths and pattern
You can change (in `mix.exs` file) the folder where your specs are and the pattern to match the files.
```elixir
 def project do
  ...
  spec_paths: ["my_specs", "espec"],
  spec_pattern: "*_espec.exs",
  ...
 end
```
#### Coverage
One can run specs with coverage:
```sh
mix espec --cover
```
Find the results in `/cover` folder.
ESpec, like ExUnit, uses very simple wrapper around OTP's cover. But you can override this.

Take a look to [coverex](https://github.com/alfert/coverex) as a perfect example.

#### Output formats
There are three formatters in ESpec: 'doc', 'json' and 'html'.

Example:
```sh
mix espec --format=doc
```
The 'doc' format will print detailed description of example and its context.

`--trace` option is an alias for `--format=doc`.
```sh
mix espec --trace
```

'html' and 'json' formatters prepare pretty HTML and JSON outputs.

You may use `--format` with `--out` option to write output to the file.
```sh
mix espec --format=html --out=spec.html
```
## Contributing
##### Contributions are welcome and appreciated!

Request a new feature by creating an issue.

Create a pull request with new features and fixes.

ESpec is tested using ExUnit and ESpec. So run:
```sh
mix test
mix espec
```
