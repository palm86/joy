defmodule Joy.Interpreter.Kerby do
  @moduledoc """
  See: http://tunes.org/~iepos/joy.html

  """
  require Logger
  use Joy.Interpreter

  @doc """
  `[B] [A] swap == [A] [B]`

  Swaps the two elements at the top of the stack.

  Composite definition:
  `swap == unit dip`
  """
  def swap(stack) do
    [a, b | rest] = stack

    [b, a | rest]
  end

  @doc """
  `[A] dup == [A] [A]`

  Duplicates the element at the top of the stack.
  """
  def dup(stack) do
    # Extract
    [head | stack] = stack

    [head, head | stack]
  end

  @doc """
  `[A] zap == `

  Pops the element at the top of the stack.
  """
  def zap(stack) do
    [_ | stack] = stack

    stack
  end

  @doc """
  `[A] unit == [[A]]`

  Quotes the element at the top of the stack.

  Composite defintion:
  `unit == [] cons`
  """
  def unit(stack) do
    [a | rest] = stack

    [[a] | rest]
  end

  @doc """
  `[B] [A] cat == [B A]`

  Concatenates the two lists at the top of the stack.

  Composite definition (require transparent quotation):
  `cat  == [[i] dip i] cons cons`
  """
  def cat(stack) do
    [a, b | rest] = stack

    case {a, b} do
      {a, b} when is_list(a) and is_list(b) -> [b ++ a | rest]
    end
  end

  @doc """
  `[B] [A] cons == [[B] A]`

  Inserts the element below the top of the stack as the head of the list on top of the stack.

  Composite definition:
  `cons == [unit] dip cat`
  """
  def cons(stack) do
    [a, b | rest] = stack

    case {a, b} do
      {a, b} when is_list(a) -> [[b | a] | rest]
    end
  end

  @doc """
  `[A] i == A`

  Interprets/unquotes the quotation/list at the top of the stack.

  Composite definition:
  `i == dup dip zap`
  """
  def i([a | rest] = _stack) when is_list(a) do
    __execute(rest, a)
  end

  @doc """
  `[B] [A] dip == A [B]`

  Pops two elements off the stack, then executes the first and pushes the second.

  Composite definition:
  `dip == swap unit cat i`
  """
  def dip([a, b | rest] = _stack) when is_list(a) and is_list(b) do
    [b | __execute(rest, a)]
  end

  @doc """
  `[A] id == [A]`

  The identify function. Does nothing.

  Composite definition (one of many):
  `id == swap swap`
  """
  def id(stack), do: stack
end
