defmodule JoyTest do
  import Joy
  use ExUnit.Case

  test "sigil_J" do
    assert ~J() == []
    assert ~J( ) == []
    assert ~J(  ) == []
    assert ~J(   ) == []
    assert ~J(a) == [:a]
    assert ~J(a ) == [:a]
    assert ~J( a) == [:a]
    assert ~J( a ) == [:a]
    assert ~J([a]) == [[:a]]
    assert ~J( [a]) == [[:a]]
    assert ~J([a] ) == [[:a]]
    assert ~J( [a] ) == [[:a]]
    assert ~J( [a []] ) == [[:a, []]]
    assert ~J"""
    [
      a
      [
        a
        [
          a
        ]
      ]
    ]
    """ == [[:a, [:a, [:a]]]]
  end
end
