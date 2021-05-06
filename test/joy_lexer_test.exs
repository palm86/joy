defmodule JoyLexerTest do
  use ExUnit.Case

  test "empty programs are valid" do
    str = ""
    assert {:ok, tokens, _} = str |> to_charlist() |> :joy_lexer.string()
    assert tokens == []
  end

  test "whitespace collapses" do
    str = " "
    assert {:ok, tokens, _} = str |> to_charlist() |> :joy_lexer.string()
    assert tokens == []

    str = "  "
    assert {:ok, tokens, _} = str |> to_charlist() |> :joy_lexer.string()
    assert tokens == []

    str = "\t"
    assert {:ok, tokens, _} = str |> to_charlist() |> :joy_lexer.string()
    assert tokens == []

    str = "\n"
    assert {:ok, tokens, _} = str |> to_charlist() |> :joy_lexer.string()
    assert tokens == []

    str = "\s\n\t\r"
    assert {:ok, tokens, _} = str |> to_charlist() |> :joy_lexer.string()
    assert tokens == []
  end

  test "newlines" do
    str = """
    [
      a
      []
    ]
    """

    assert {:ok, tokens, _} = str |> to_charlist() |> :joy_lexer.string()

    assert tokens == [
             {:"[", 1},
             {:function, 2, :a},
             {:"[", 3},
             {:"]", 3},
             {:"]", 4},
           ]
  end

  test "comments" do
    str = """
    [
      a # just a comment
      []
    ]
    """

    assert {:ok, tokens, _} = str |> to_charlist() |> :joy_lexer.string()

    assert tokens == [
             {:"[", 1},
             {:function, 2, :a},
             {:"[", 3},
             {:"]", 3},
             {:"]", 4},
           ]
  end
end
