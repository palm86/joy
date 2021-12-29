defmodule Joy.Formatter do
  def format(result, opts \\ []) do
    direction = Keyword.get(opts, :direction, :program)

    formatted =
      case direction do
        :program -> do_format(result, true)
        :stack -> do_format(Enum.reverse(result), true)
      end

    IO.iodata_to_binary(formatted)
  end

  defp do_format(elem, true = _first) when is_list(elem) do
    elem
    |> Enum.map(&do_format(&1, false))
    |> Enum.intersperse(" ")
  end

  defp do_format(elem, false = _first) when is_list(elem) do
    ["[", do_format(elem, true), "]"]
  end

  defp do_format(elem, _first) when is_atom(elem) do
    Atom.to_string(elem)
  end
end
