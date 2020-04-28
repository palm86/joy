defmodule Joy.REPL do
  @splash """
     _
    |_|___ _ _
    | | . | | |
   _| |___|_  |
  |___|   |___|

  Interactive Joy - press Ctrl+C to exit
  """

  def main(_args \\ []) do
    Joy.REPL.Engine.start_link()

    IO.puts(IO.ANSI.cyan() <> @splash <> IO.ANSI.white())

    loop()
  end

  defp loop() do
    input = IO.gets(IO.ANSI.magenta() <> "joy> " <> IO.ANSI.white())

    with {:ok, parsed_input} <- Joy.Parser.parse(input),
         {:ok, stack} <- Joy.REPL.Engine.push(parsed_input) do
      stack
      |> Joy.Formatter.format(direction: :stack)
      |> IO.puts()
    else
      {:error, reason} ->
        IO.puts(IO.ANSI.red() <> "Error: #{inspect(reason)}" <> IO.ANSI.white())
    end

    loop()
  end

  defmodule Engine do
    use GenServer

    def start_link(init_args \\ []) do
      GenServer.start_link(__MODULE__, init_args, name: __MODULE__)
    end

    def init(args) do
      {:ok, args}
    end

    def push(parsed_input) do
      GenServer.call(__MODULE__, {:push, parsed_input}, :infinity)
    end

    def handle_call({:push, input}, _from, state) do
      case Joy.Interpreter.interpret(input, state) do
        {:ok, stack} -> {:reply, {:ok, stack}, stack}
        {:error, any} -> {:reply, {:error, any}, state}
      end
    end
  end
end
