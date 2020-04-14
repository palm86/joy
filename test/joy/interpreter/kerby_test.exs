defmodule Joy.Interpreter.KerbyTest do
  # source of examples = http://tunes.org/~iepos/joy.html
  use ExUnit.Case
  # import Joy.Interpreter, only: [interpret: 1]
  import Joy, only: [sigil_J: 2]

  test "swap" do
    # [B] [A] swap == [A] [B]
    assert ~J([b] [a] swap) == ~J([a] [b])
  end

  test "dup" do
    # [A] dup  == [A] [A]
    assert ~J([a] dup) == ~J([a] [a])
  end

  test "zap" do
    # [A] zap ==
    assert ~J([a] zap) == ~J()
  end

  test "cat" do
    # [B] [A] cat  == [B A]
    assert ~J([b] [a] cat) == ~J([b a])
  end

  test "cons" do
    # [B] [A] cons == [[B] A]
    assert ~J([b] [a] cons) == ~J([[b] a])
  end

  test "unit" do
    # [A] unit == [[A]]
    assert ~J([a] unit) == ~J([[a]])
  end

  test "i" do
    # [A] i == A
    assert ~J([a] i) == ~J(a)
  end

  test "dip" do
    # [B] [A] i == A [B]
    assert ~J([b] [a] dip) == ~J(a [b])
  end
end
