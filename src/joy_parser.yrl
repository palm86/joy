Rootsymbol program.
Nonterminals program quotation elems elem.
Terminals '[' ']' function.

program -> '$empty' : [].
program -> elems : '$1'.

elems -> elem : ['$1'].
elems -> elem elems : ['$1' | '$2'].

elem -> function : extract_value('$1').
elem -> quotation : '$1'.

quotation -> '[' program ']' : '$2'.

Erlang code.

extract_value({_Token, _Line, Value}) -> Value.
