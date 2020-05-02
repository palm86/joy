# Joy

Minimal Joy parser and interpreter

## Installation

The package can be installed by adding `joy` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:joy, git: "https://github.com/palm86/joy.git", tag: "0.1.0"}
  ]
end
```

Or clone the repository and run `mix escript.build` to add the `joy` executable to `~/bin`.
You can then run `joy` from a terminal to launch an interactive Joy shell.

## Usage

The best way to explore Joy is to run it in the interactiv shell. After installation the
`joy` executable lives in `~/bin` which is usually on your PATH. If not, run it with
`~/bin/joy`.

```
   _
  |_|___ _ _
  | | . | | |
 _| |___|_  |
|___|   |___|

Interactive Joy (0.1.0) - press Ctrl+C to exit

joy> 
```

You can also launch the REPL in any other project by calling `Joy.REPL.main()`.

### Syntax

This is (currently) a minimal version of Joy which only supports quotations and functions.
There is no support for numerals, characters, strings and sets. The booleans `true` and `false`
are however supported.

Functions can be anything that matches the regex `[a-z_0-9\-]+`. So any word made of alphanumerics,
dashes and underscores.

Quotations or "program literals" are wrapped inside a pair of square brackets `[` and `]`.

The following is a valid Joy program:

```
[dup cons] dup cons
```

When executed, it leaves a quoted copy of itself on the stack.

### Parsing

You can parse any Joy program with `Joy.Parser.parse/1`. The output is a potentially
empty list of atoms and more lists.

### Interpreters

Parsed Joy programs can be interpreted with `Joy.Interpreter.interpret/2`.
The actual interpreter is pluggable. The default interpreter only supports the 
`dup`, `cons`, `dip`, `i`, `zap`, `unit`, `swap` and `cat` functions.

You can implement your own interpreter by implementing the `Joy.Interpreter` behaviour:


``` elixir
defmodule MyInterpreter do
  use Joy.Interpreter

  def myfunc(stack) do
    [:"my-special-stack-effect" | stack]
  end
end
```

In the module above the `myfunc` function is defined. It takes a stack as input
and must return a stack as output. See the source for `Joy.Interpreter` and
`Joy.Interpreter.Kerby` for examples.

Instead of defining your own interpreter, you can temporarily extend the functions
available to the interpreter by defining your own. This is mostly useful in the REPL:

```
joy> [myfunc] [[] dup cat]
myfunc == [] dup cat 
```

Now the function `myfunc` is available for the remainder of your session.

### ~J sigil

Joy prorams can be parsed and interpreted in one go with the `~J` sigil:

```
import Joy
~J"[] dup cat"
```

### Formatting

The output of both the parser and the interpreter is a list. In the case of parsing,
the list represents the Joy program. In the case of interpreting, the list represents
the stack. You can format either of these with `Joy.Formatter.format/2`. Provide the
`direction` option to indicate when you want to format a stack:

```
Joy.Formatter.format(stack, direction: :stack)
```