defmodule Joy.Interpreter do
  @type program :: list(func_or_quot)
  @type func_or_quot :: func | quot
  @type func :: atom
  @type quot :: [program]

  @type stack :: list(func_or_quot)

  @callback __execute(stack, program) :: stack

  defmacro __using__(_opts) do
    quote do
      def __execute(stack, [] = _program) when is_list(stack) do
        stack
      end

      def __execute(stack, [function_or_quotation | program])
          when (is_list(stack) and is_list(function_or_quotation)) or
                 is_atom(function_or_quotation) do
        new_stack = __apply(function_or_quotation, stack)

        if Process.get()[:steps] || false and program != [] do
          IO.puts([
            IO.ANSI.faint(),
            IO.ANSI.cyan(),
            Joy.Formatter.format(new_stack, direction: :stack),
            " ",
            IO.ANSI.white(),
            Joy.Formatter.format(program),
            IO.ANSI.normal()
          ])
        end

        __execute(new_stack, program)
      end

      defp __apply(function, stack) when is_atom(function) do
        cond do
          Kernel.function_exported?(__MODULE__, function, 1) ->
            Kernel.apply(__MODULE__, function, [stack])

          function in Map.keys(Process.get()[:custom_definitions] || %{}) ->
            func = Process.get()[:custom_definitions][function]
            func.(stack)

          true ->
            [function | stack]
        end
      end

      defp __apply(quotation, stack) when is_list(quotation) do
        [quotation | stack]
      end

      @doc """
      `[name] [body] define == `

      Defines a function `name` that executes `[body] such that `name == body`.
      """
      def define(stack) do
        [quotation, [name] | rest] = stack

        func = fn fn_stack ->
          fn_stack
          |> __execute(quotation)
        end

        custom_definitions =
          (Process.get()[:custom_definitions] || %{})
          |> Map.put(name, func)

        Process.put(:custom_definitions, custom_definitions)

        IO.puts(
          IO.ANSI.yellow() <>
            "#{name} == #{Joy.Formatter.format(quotation)}" <> IO.ANSI.white()
        )

        rest
      end

      @doc """
      `steps == `

      Toggles steps mode. If steps mode is active intermediary results are printed to the output.
      """
      def steps(stack) do
        current_steps_mode = Process.get()[:steps] || false

        Process.put(:steps, not current_steps_mode)

        IO.puts([
          IO.ANSI.yellow(),
          "Steps mode: ",
          to_string(not current_steps_mode),
          IO.ANSI.white()
        ])

        stack
      end

      @doc """
      `help == ` or `[name] help == `

      Prints a general or function-specific help message.
      """
      def help(stack) do
        {:docs_v1, _annotation, :elixir, _format, _module_doc, _metadata, docs} =
          Code.fetch_docs(__MODULE__)

        case stack do
          [[name] | stack] ->
            docs
            |> Enum.each(fn
              {{:function, ^name, 1}, _, _, %{"en" => doc_content}, _metadata} ->
                unless String.starts_with?(to_string(name), "_") do
                  IO.puts(IO.ANSI.yellow() <> "\n" <> doc_content <> IO.ANSI.white() <> "\n")
                end

              _ ->
                :ok
            end)

            stack

          stack ->
            IO.puts(
              IO.ANSI.yellow() <>
                "\nUsing backend #{inspect(__MODULE__)} which defines the following functions:\n"
            )

            docs
            |> Enum.each(fn
              {{:function, name, 1}, _, _, %{"en" => doc_content}, _metadata} ->
                unless String.starts_with?(to_string(name), "_") do
                  IO.puts("  * " <> to_string(name))
                end

              _ ->
                :ok
            end)

            IO.puts(
              "\nUse `[name] help` to learn more about a specific function" <> IO.ANSI.yellow()
            )

            stack
        end
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
