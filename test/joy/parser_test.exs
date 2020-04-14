defmodule Joy.ParserTest do
  alias Joy.Parser
  use ExUnit.Case

  test "parse" do
    assert Parser.parse("") == []
    assert Parser.parse(" ") == []
    assert Parser.parse("   ") == []
    assert Parser.parse("[]") == [[]]
    assert Parser.parse(" []") == [[]]
    assert Parser.parse("[] ") == [[]]
    assert Parser.parse(" [] ") == [[]]
    assert Parser.parse("[ ]") == [[]]
    assert Parser.parse("[  ]") == [[]]
    assert Parser.parse("[   ]") == [[]]
    assert Parser.parse("a") == [:a]
    assert Parser.parse(" a") == [:a]
    assert Parser.parse("a ") == [:a]
    assert Parser.parse(" a ") == [:a]
    assert Parser.parse("[ a]") == [[:a]]
    assert Parser.parse("[a ]") == [[:a]]
    assert Parser.parse("[ a ]") == [[:a]]
    assert Parser.parse(" [a]") == [[:a]]
    assert Parser.parse("[a] ") == [[:a]]
    assert Parser.parse(" [a] ") == [[:a]]
    assert Parser.parse(" [ a ]") == [[:a]]
    assert Parser.parse("[ a ] ") == [[:a]]
    assert Parser.parse(" [ a ] ") == [[:a]]
    assert Parser.parse("[ a a]") == [[:a, :a]]
    assert Parser.parse("[a a ]") == [[:a, :a]]
    assert Parser.parse("[ a a ]") == [[:a, :a]]
    assert Parser.parse("[ a []]") == [[:a, []]]
    assert Parser.parse("[a [] ]") == [[:a, []]]
    assert Parser.parse("[ a [] ]") == [[:a, []]]
    assert Parser.parse("[ a [a]]") == [[:a, [:a]]]
    assert Parser.parse("[a [a] ]") == [[:a, [:a]]]
    assert Parser.parse("[ a [a] ]") == [[:a, [:a]]]
    assert Parser.parse("[ [] a]") == [[[], :a]]
    assert Parser.parse("[[] a ]") == [[[], :a]]
    assert Parser.parse("[ [] a ]") == [[[], :a]]
    assert Parser.parse("[ [a] []]") == [[[:a], []]]
    assert Parser.parse("[[a] [] ]") == [[[:a], []]]
    assert Parser.parse("[ [a] [] ]") == [[[:a], []]]

    multiline = """
    a
    a
    [
      a
    ]

    """

    assert Parser.parse(multiline) == [:a, :a, [:a]]

    multiline = """
    [
    a
    []
    ]
    """

    assert Parser.parse(multiline) == [[:a, []]]

    multiline = """
    [
              a
              [
                a
                [
                  a
                ]
              ]
            ]
    """

    assert Parser.parse(multiline) == [[:a, [:a, [:a]]]]
  end
end
