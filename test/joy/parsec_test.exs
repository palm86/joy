defmodule Joy.ParsecTest do
  alias Joy.Parsec
  use ExUnit.Case

  test "parses various scenarios successfully" do
    # {:ok, acc, rest, context, line, offset}
    assert Parsec.parse!("") == {:ok, [], "", %{}, {1, 0}, 0}
    assert Parsec.parse!(" ") == {:ok, [], "", %{}, {1, 0}, 1}
    assert Parsec.parse!("   ") == {:ok, [], "", %{}, {1, 0}, 3}
    assert Parsec.parse!("[]") == {:ok, [[]], "", %{}, {1, 0}, 2}
    assert Parsec.parse!(" []") == {:ok, [[]], "", %{}, {1, 0}, 3}
    assert Parsec.parse!("[] ") == {:ok, [[]], "", %{}, {1, 0}, 3}
    assert Parsec.parse!(" [] ") == {:ok, [[]], "", %{}, {1, 0}, 4}
    assert Parsec.parse!("[ ]") == {:ok, [[]], "", %{}, {1, 0}, 3}
    assert Parsec.parse!("[  ]") == {:ok, [[]], "", %{}, {1, 0}, 4}
    assert Parsec.parse!("[   ]") == {:ok, [[]], "", %{}, {1, 0}, 5}
    assert Parsec.parse!("a") == {:ok, ["a"], "", %{}, {1, 0}, 1}
    assert Parsec.parse!(" a") == {:ok, ["a"], "", %{}, {1, 0}, 2}
    assert Parsec.parse!("a ") == {:ok, ["a"], "", %{}, {1, 0}, 2}
    assert Parsec.parse!(" a ") == {:ok, ["a"], "", %{}, {1, 0}, 3}
    assert Parsec.parse!("  a ") == {:ok, ["a"], "", %{}, {1, 0}, 4}
    assert Parsec.parse!("   a") == {:ok, ["a"], "", %{}, {1, 0}, 4}
    assert Parsec.parse!("[ a]") == {:ok, [["a"]], "", %{}, {1, 0}, 4}
    assert Parsec.parse!("[a   ]") == {:ok, [["a"]], "", %{}, {1, 0}, 6}
    assert Parsec.parse!("[ a  ]") == {:ok, [["a"]], "", %{}, {1, 0}, 6}
    assert Parsec.parse!("[  a ]") == {:ok, [["a"]], "", %{}, {1, 0}, 6}
    assert Parsec.parse!("[   a]") == {:ok, [["a"]], "", %{}, {1, 0}, 6}
    assert Parsec.parse!(" [a]") == {:ok, [["a"]], "", %{}, {1, 0}, 4}
    assert Parsec.parse!("[a] ") == {:ok, [["a"]], "", %{}, {1, 0}, 4}
    assert Parsec.parse!(" [a] ") == {:ok, [["a"]], "", %{}, {1, 0}, 5}
    assert Parsec.parse!(" [ a ]") == {:ok, [["a"]], "", %{}, {1, 0}, 6}
    assert Parsec.parse!("[ a ] ") == {:ok, [["a"]], "", %{}, {1, 0}, 6}
    assert Parsec.parse!(" [ a ] ") == {:ok, [["a"]], "", %{}, {1, 0}, 7}
    assert Parsec.parse!("[ a a]") == {:ok, [["a", "a"]], "", %{}, {1, 0}, 6}
    assert Parsec.parse!("[a a ]") == {:ok, [["a", "a"]], "", %{}, {1, 0}, 6}
    assert Parsec.parse!("[ a a ]") == {:ok, [["a", "a"]], "", %{}, {1, 0}, 7}
    assert Parsec.parse!("[ a []]") == {:ok, [["a", []]], "", %{}, {1, 0}, 7}
    assert Parsec.parse!("[a [] ]") == {:ok, [["a", []]], "", %{}, {1, 0}, 7}
    assert Parsec.parse!("[ a [] ]") == {:ok, [["a", []]], "", %{}, {1, 0}, 8}
    assert Parsec.parse!("[ a [a]]") == {:ok, [["a", ["a"]]], "", %{}, {1, 0}, 8}
    assert Parsec.parse!("[a [a] ]") == {:ok, [["a", ["a"]]], "", %{}, {1, 0}, 8}
    assert Parsec.parse!("[ a [a] ]") == {:ok, [["a", ["a"]]], "", %{}, {1, 0}, 9}
    assert Parsec.parse!("[ [] a]") == {:ok, [[[], "a"]], "", %{}, {1, 0}, 7}
    assert Parsec.parse!("[[] a ]") == {:ok, [[[], "a"]], "", %{}, {1, 0}, 7}
    assert Parsec.parse!("[ [] a ]") == {:ok, [[[], "a"]], "", %{}, {1, 0}, 8}
    assert Parsec.parse!("[ [a] []]") == {:ok, [[["a"], []]], "", %{}, {1, 0}, 9}
    assert Parsec.parse!("[[a] [] ]") == {:ok, [[["a"], []]], "", %{}, {1, 0}, 9}
    assert Parsec.parse!("[ [a] [] ]") == {:ok, [[["a"], []]], "", %{}, {1, 0}, 10}

    multiline = """
    a
    a
    [
      a
    ]

    """

    assert Parsec.parse!(multiline) == {:ok, ["a", "a", ["a"]], "", %{}, {7, 13}, 13}

    multiline = """
    [
    a
    []
    ]
    """

    assert Parsec.parse!(multiline) == {:ok, [["a", []]], "", %{}, {5, 9}, 9}

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

    assert Parsec.parse!(multiline) == {:ok, [["a", ["a", ["a"]]]], "", %{}, {10, 106}, 106}
  end

  test "parses and fails in some cases" do
    # TODO fail if rest is not empty
    assert Parsec.parse!("[") == {:ok, [], "[", %{}, {1, 0}, 0}
  end
end
