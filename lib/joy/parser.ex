defmodule Joy.Parser do
  @type program :: list(func_or_quot)
  @type func_or_quot :: func | quot
  @type func :: atom
  @type quot :: [program]

  @spec parse(binary) :: program
  def parse(str) do
    with {:ok, tokens, _} <- str |> to_charlist() |> :joy_lexer.string(),
         {:ok, joy} <- :joy_parser.parse(tokens) do
      joy
    end
  end
end
