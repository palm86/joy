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

      {:error, parser_error} ->
        if bang do
          raise "parser error"
        else
          {:error, "parser error: #{inspect(parser_error)}"}
        end
    end
  end

  def tryme() do
    # :joy_lexer.tokens()
    :io.request(:stdout, {:get_until, :unicode, "prompt", :joy_lexer, :tokens, [0]})
  end

  def collect_action(chars, line, cont_0) do
    case :joy_lexer.tokens(cont_0, chars, line) do
        {:done, {:ok, tokens, _},_} -> {:ok, tokens, line};

        {:done, {:eof, _},_} -> {:eof, line};

        {:done, {:error, error, _},_} -> {:error, error,line};

        {:more, cont_1} ->
            collect_action(IO.gets("Miaau") |> to_charlist(), line + 1, cont_1)
    end
  end

  def test() do
    :joy_parser.parse_and_scan({__MODULE__, :tryme, []})
  end
end
