defmodule JoyParserTest do
  alias :joy_parser, as: Parser
  use ExUnit.Case

  test "newlines" do
    tokens = [
      {:"[", 1},
      {:function, 2, :a},
      {:"[", 3},
      {:"]", 3},
      {:"]", 4},
    ]

    assert {:ok, program} = Parser.parse(tokens)
    assert program == [[:a, []]]
  end
end
