% See: https://andrealeopardi.com/posts/tokenizing-and-parsing-in-elixir-using-leex-and-yecc/

Definitions.

FUNCTION       = [a-z_0-9\-]+
WHITESPACE     = [\s\t\n\r]+

Rules.

{FUNCTION}        : {token, {function, TokenLine, to_atom(TokenChars)}}.
\[                : {token, {'[',  TokenLine}}.
\]                : {token, {']',  TokenLine}}.
{WHITESPACE}      : skip_token.

Erlang code.

to_atom(Chars) ->
  list_to_atom(Chars).
