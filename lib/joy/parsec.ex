defmodule Joy.Parsec do
  import NimbleParsec

  func = ascii_string([?0..?9, ?a..?z, ?!, ?^, ?%, ?*, ?+, ?-, ?/, ?<..??], min: 1)

  whitespace = repeat(ascii_char([?\n, ?\t, ?\s]))

  quotation =
    ignore(string("["))
    |> ignore(whitespace)
    |> repeat(parsec(:element))
    |> ignore(string("]"))
    |> wrap()

  defcombinatorp(
    :element,
    choice([func, quotation]) |> ignore(whitespace),
    inline: true,
    export_metadata: true
  )

  defparsec(:parse!, ignore(whitespace) |> repeat(parsec(:element)), inline: true, export_metadata: true)
end
