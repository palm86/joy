defmodule Joy.Interpreter do
  @type program :: list(func_or_quot)
  @type func_or_quot :: func | quot
  @type func :: atom
  @type quot :: [program]

  @type stack :: list(func_or_quot)

  @callback __execute(stack, program) :: stack

  defmacro __using__(_opts) do
    quote do
      def __execute(stack, program) when is_list(stack) and is_list(program) do
        Enum.reduce(program, stack, fn
          function, stack when is_atom(function) ->
            cond do
              Kernel.function_exported?(__MODULE__, function, 1) ->
                Kernel.apply(__MODULE__, function, [stack])

              function in Map.keys(Process.get()[:custom_definitions] || %{}) ->
                func = Process.get()[:custom_definitions][function]
                func.(stack)

              true ->
                [function | stack]
            end

          quotation, stack when is_list(quotation) ->
            [quotation | stack]
        end)
      end

      def define(stack) do
        [quotation, [name] | rest] = stack

        func = fn fn_stack ->
          fn_stack
          |> __execute(quotation)
        end

        custom_definitions =
          Process.get()[:custom_definitions] ||
            %{}
            |> Map.put(name, func)

        Process.put(:custom_definitions, custom_definitions)

        IO.puts(
          IO.ANSI.yellow() <>
            "#{name} == #{Joy.Formatter.format(quotation)}" <> IO.ANSI.white()
        )

        rest
      end
    end
  end

  @spec interpret!(program, stack) :: stack
  def interpret!(program, stack \\ []) do
    do_interpret(program, stack)
  end

  @spec interpret(program, stack) :: {:ok, stack} | {:error, any}
  def interpret(program, stack \\ []) do
    try do
      {:ok, do_interpret(program, stack)}
    rescue
      e ->
        {:error, inspect(e)}
    end
  end

  defp do_interpret(program, stack) when is_list(program) do
    impl = Application.get_env(:joy, __MODULE__)[:implementation] || Joy.Interpreter.Kerby
    impl.__execute(stack, program)
  end
end
