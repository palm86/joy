defmodule Joy.FormatterTest do
  import Joy, only: [sigil_J: 2]
  alias Joy.Formatter
  alias Joy.Parser
  use ExUnit.Case

  test "format program" do
    assert ~J()p |> Formatter.format() == ""
    assert ~J( )p |> Formatter.format() == ""
    assert ~J(   )p |> Formatter.format() == ""
    assert ~J([])p |> Formatter.format() == "[]"
    assert ~J( [])p |> Formatter.format() == "[]"
    assert ~J([] )p |> Formatter.format() == "[]"
    assert ~J( [] )p |> Formatter.format() == "[]"
    assert ~J([ ])p |> Formatter.format() == "[]"
    assert ~J([  ])p |> Formatter.format() == "[]"
    assert ~J([   ])p |> Formatter.format() == "[]"
    assert ~J(a)p |> Formatter.format() == "a"
    assert ~J( a)p |> Formatter.format() == "a"
    assert ~J(a )p |> Formatter.format() == "a"
    assert ~J( a )p |> Formatter.format() == "a"
    assert ~J([ a])p |> Formatter.format() == "[a]"
    assert ~J([a ])p |> Formatter.format() == "[a]"
    assert ~J([ a ])p |> Formatter.format() == "[a]"
    assert ~J( [a])p |> Formatter.format() == "[a]"
    assert ~J([a] )p |> Formatter.format() == "[a]"
    assert ~J( [a] )p |> Formatter.format() == "[a]"
    assert ~J( [ a ])p |> Formatter.format() == "[a]"
    assert ~J([ a ] )p |> Formatter.format() == "[a]"
    assert ~J( [ a ] )p |> Formatter.format() == "[a]"
    assert ~J([ a a])p |> Formatter.format() == "[a a]"
    assert ~J([a a ])p |> Formatter.format() == "[a a]"
    assert ~J([ a a ])p |> Formatter.format() == "[a a]"
    assert ~J([ a []])p |> Formatter.format() == "[a []]"
    assert ~J([a [] ])p |> Formatter.format() == "[a []]"
    assert ~J([ a [] ])p |> Formatter.format() == "[a []]"
    assert ~J([ a [a]])p |> Formatter.format() == "[a [a]]"
    assert ~J([a [a] ])p |> Formatter.format() == "[a [a]]"
    assert ~J([ a [a] ])p |> Formatter.format() == "[a [a]]"
    assert ~J([ [] a])p |> Formatter.format() == "[[] a]"
    assert ~J([[] a ])p |> Formatter.format() == "[[] a]"
    assert ~J([ [] a ])p |> Formatter.format() == "[[] a]"
    assert ~J([ [a] []])p |> Formatter.format() == "[[a] []]"
    assert ~J([[a] [] ])p |> Formatter.format() == "[[a] []]"
    assert ~J([ [a] [] ])p |> Formatter.format() == "[[a] []]"
  end

  test "format stack" do
    assert [[:a], [:b]] |> Formatter.format(direction: :stack) == "[b] [a]"
  end
end
