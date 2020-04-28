defmodule Joy.Formatter do
  def format(result, opts \\ []) do
    direction = Keyword.get(opts, :direction, :program)

    formatted =
      case direction do
        :program -> do_format(result, "")
        :stack -> do_format(Enum.reverse(result), "")
      end

    String.slice(formatted, 1, String.length(formatted) - 2)
  end

  defp do_format(elem, acc) when is_list(elem) do
    initial =
      cond do
        acc == "" -> "["
        String.ends_with?(acc, "[") -> acc <> "["
        true -> acc <> " " <> "["
      end

    formatted =
      elem
      |> Enum.reduce(initial, &do_format(&1, &2))

    formatted <> "]"
  end

  defp do_format(elem, acc) when is_atom(elem) do
    cond do
      String.ends_with?(acc, "[") -> acc <> to_string(elem)
      true -> acc <> " " <> to_string(elem)
    end
  end
end
