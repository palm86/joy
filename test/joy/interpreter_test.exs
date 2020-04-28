defmodule Joy.InterpreterTest do
  import Joy, only: [sigil_J: 2]
  alias Joy.Interpreter
  use ExUnit.Case

  test "run" do
    assert Interpreter.interpret!(~J()p) == ~J()

    assert Interpreter.interpret!(~J(a)p) == ~J(a)

    assert ~J(a dup)p == [:a, :dup]
    assert ~J(a dup) == [:a, :a]
    assert Interpreter.interpret!(~J(a dup)p) == ~J(a dup)
  end
end
