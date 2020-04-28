defmodule Joy do
  @type program :: list(func_or_quot)
  @type func_or_quot :: func | quot
  @type func :: atom
  @type quot :: [program]

  @type stack :: list(func_or_quot)

  @spec sigil_J(binary, any) :: program | stack
  def sigil_J(string, [?p]) do
    string
    |> Joy.Parser.parse!()
  end

  def sigil_J(string, _) do
    string
    |> Joy.Parser.parse!()
    |> Joy.Interpreter.interpret!()
  end

  @spec sigil_Q(binary, any) :: func_or_quot
  def sigil_Q(string, _) do
    [quotation] = Joy.Parser.parse!(string)
    quotation
  end
end
