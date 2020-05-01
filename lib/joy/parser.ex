defmodule Joy.Parser do
  @type program :: list(func_or_quot)
  @type func_or_quot :: func | quot
  @type func :: atom
  @type quot :: [program]

  @spec parse(binary) :: {:ok, program} | {:error, any}
  def parse(str) when is_binary(str) do
    with {:ok, tokens, _} <- str |> to_charlist() |> :joy_lexer.string(),
         {:ok, joy} <- :joy_parser.parse(tokens) do
      {:ok, joy}
    else
      {:error, {_, :joy_lexer, {_, _}}, _} ->
        {:error, "invalid token"}

      {:error, _} ->
        {:error, "parser error"}
    end
  end

  @spec parse!(binary) :: program | no_return
  def parse!(str) when is_binary(str) do
    with {:ok, tokens, _} <- str |> to_charlist() |> :joy_lexer.string(),
         {:ok, joy} <- :joy_parser.parse(tokens) do
      joy
    else
      {:error, {_, :joy_lexer, {_, _}}, _} ->
        raise "invalid token"

      {:error, _} ->
        raise "parser error"
    end
  end
end
