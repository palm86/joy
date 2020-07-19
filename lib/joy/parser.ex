defmodule Joy.Parser do
  @type program :: list(func_or_quot)
  @type func_or_quot :: func | quot
  @type func :: atom
  @type quot :: [program]

  @spec parse(binary, keyword) :: {:ok, program} | {:error, any}
  def parse(str, opts \\ []) when is_binary(str) do
    do_parse(str, Keyword.put(opts, :bang, false))
  end

  @spec parse!(binary, keyword) :: program | no_return
  def parse!(str, opts \\ []) when is_binary(str) do
    do_parse(str, Keyword.put(opts, :bang, true))
  end

  defp do_parse(str, opts) when is_binary(str) do
    bang = Keyword.get(opts, :bang, false)

    with {:ok, tokens, _} <- str |> to_charlist() |> :joy_lexer.string(),
         {:ok, joy} <- :joy_parser.parse(tokens) do
      if bang do
        joy
      else
        {:ok, joy}
      end
    else
      {:error, {_, :joy_lexer, {_, _}}, _} ->
        if bang do
          raise "invalid token"
        else
          {:error, "invalid token"}
        end

      {:error, _} ->
        if bang do
          raise "parser error"
        else
          {:error, "parser error"}
        end
    end
  end
end
