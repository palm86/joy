defmodule Joy.REPL do
  @splash """
     _
    |_|___ _ _
    | | . | | |
   _| |___|_  |
  |___|   |___|

  Interactive Joy (#{String.trim(File.read!("VERSION"))}) - press Ctrl+C to exit
  """

  def main(_args \\ []) do
    # Joy.REPL.Engine.start_link()

    IO.puts(IO.ANSI.cyan() <> @splash <> IO.ANSI.white())

    loop([])
  end

  defp loop(stack) do
    # read
    input = IO.gets(IO.ANSI.magenta() <> "joy> " <> IO.ANSI.white())

    # evaluate
    stack =
      with {:ok, parsed_input} <- Joy.Parser.parse(input),
           {:ok, stack} <- Joy.Interpreter.interpret(parsed_input, stack) do
        # print
        stack
        |> Joy.Formatter.format(direction: :stack)
        |> IO.puts()

        stack
      else
        {:error, reason} ->
          # print
          IO.puts(IO.ANSI.red() <> "Error: #{inspect(reason)}" <> IO.ANSI.white())

          stack
      end

    # loop
    loop(stack)
  end
end
