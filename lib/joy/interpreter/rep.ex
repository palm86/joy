defmodule Joy.Interpreter.Rep do
  @moduledoc """
  See: http://tunes.org/~iepos/joy.html

  """
  use Joy.Interpreter
  require Logger

  def duco(stack) do
    stack
    |> dup()
    |> cons()
  end

  def dureco(stack) do
    stack
    |> dup()
    |> rest()
    |> cons()
  end

  def rest(stack) do
    # Extract
    [[_head | rest] | stack] = stack

    [rest | stack]
  end

  def infra([quotation, new_stack | old_stack] = _stack) do
    [__execute(new_stack, quotation) | old_stack]
  end

  @doc """
  [B] [A] swap == [A] [B]

  Alt: swap == unit dip
  """
  def swap(stack) do
    [a, b | rest] = stack

    [b, a | rest]
  end

  @doc """
  [A] dup  == [A] [A]

  Alt: swap == unit dip
  """
  def dup(stack) do
    # Extract
    [head | stack] = stack

    [head, head | stack]
  end

  @doc """
  [A] zap  ==
  """
  def pop(stack) do
    [_ | stack] = stack

    stack
  end

  @doc """
  # [A] unit == [[A]]

  Alt: unit == [] cons
  """
  def unit(stack) do
    [a | rest] = stack

    [[a] | rest]
  end

  @doc """
   [B] [A] cat == [B A]

   Alt (requires transparent quotation): cat  == [[i] dip i] cons cons
  """
  def cat(stack) do
    [a, b | rest] = stack

    case {a, b} do
      {a, b} when is_list(a) and is_list(b) -> [b ++ a | rest]
    end
  end

  @doc """
  [B] [A] cons == [[B] A]

  Alt: cons == [unit] dip cat
  """
  def cons(stack) do
    [a, b | rest] = stack

    case {a, b} do
      {a, b} when is_list(a) -> [[b | a] | rest]
    end
  end

  @doc """
  [A] i == A

  Alt: i == dup dip zap
  """
  def i([a | rest] = _stack) when is_list(a) do
    __execute(rest, a)
  end

  @doc """
  [B] [A] dip == A [B]

  Also, dip == swap unit cat i
  """
  def dip([a, b | rest] = _stack) when is_list(a) and is_list(b) do
    [b | __execute(rest, a)]
  end

  def id(stack), do: stack
end
