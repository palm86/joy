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
            if Kernel.function_exported?(__MODULE__, function, 1) do
              Kernel.apply(__MODULE__, function, [stack])
            else
              [function | stack]
            end

          quotation, stack when is_list(quotation) ->
            [quotation | stack]
        end)
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
    impl = Application.get_env(:joy, __MODULE__)[:interpreter] || Joy.Interpreter.Kerby
    impl.__execute(stack, program)
  end
end
