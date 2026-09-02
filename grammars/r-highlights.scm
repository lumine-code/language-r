; highlights.scm

; Literals

(integer) @constant.numeric.r
(float) @constant.numeric.r
(complex) @constant.numeric.r

(string) @string.quoted.double.r
(string (string_content (escape_sequence) @constant.character.escape.r))

; Comments

(comment) @comment.line.r

; Operators

[
  "?" ":=" "=" "<-" "<<-" "->" "->>"
  "~" "|>" "||" "|" "&&" "&"
  "<" "<=" ">" ">=" "==" "!="
  "+" "-" "*" "/" "::" ":::"
  "**" "^" "$" "@" ":" "!"
  "special"
] @keyword.operator.r

; Punctuation

"(" @punctuation.definition.arguments.begin.bracket.round.r
")" @punctuation.definition.arguments.end.bracket.round.r
"{" @punctuation.definition.block.begin.bracket.curly.r
"}" @punctuation.definition.block.end.bracket.curly.r

; `[` subsets, `[[` extracts a single element.
"[" @punctuation.definition.subset.begin.bracket.square.r
"]" @punctuation.definition.subset.end.bracket.square.r
"[[" @punctuation.definition.extract.begin.bracket.square.r
"]]" @punctuation.definition.extract.end.bracket.square.r

(comma) @punctuation.separator.comma.r

; Variables

(identifier) @variable.other.r

; Functions

(binary_operator
    lhs: (identifier) @entity.name.function.r
    operator: "<-"
    rhs: (function_definition)
)

(binary_operator
    lhs: (identifier) @entity.name.function.r
    operator: "="
    rhs: (function_definition)
)

; Calls

(call function: (identifier) @entity.name.function.r)

; - `return` is just a regular identifier in our grammar (#189), but people
;   expect `return()` to be highlighted
; - We feel confident that we can use `#eq?` here, as other grammars use
;   `#eq?` and `#match?` predicates already, even though support for predicates
;   is dependent on the library that binds to tree-sitter's C library, not the
;   C library itself.
;   https://github.com/tree-sitter/tree-sitter-javascript/blob/58404d8cf191d69f2674a8fd507bd5776f46cb11/queries/highlights.scm#L65-L67
;   https://github.com/tree-sitter/tree-sitter-rust/blob/77a3747266f4d621d0757825e6b11edcbf991ca5/queries/highlights.scm#L9-L11
; - Placed after `(call function: (identifier) @function)` for correct precedence
(
    (call function: (identifier) @keyword.control.r)
    (#eq? @keyword.control.r "return")
)

; Parameters

(parameter
    name: (identifier) @variable.parameter.r
    (#is? test.typeAt "parent.parent parameters")
)
(argument
    name: (identifier) @variable.parameter.r
    (#is? test.typeAt "parent.parent arguments")
)

; Namespace

(namespace_operator lhs: (identifier) @entity.name.namespace.r)

(call
    function: (namespace_operator rhs: (identifier) @entity.name.function.r)
)

; Keywords

(function_definition name: "function" @storage.type.function.r)
(function_definition name: "\\" @keyword.operator.r)

[
  "in"
  (next)
  (break)
] @keyword.control.r

[
  "if"
  "else"
] @keyword.control.conditional.r

[
  "while"
  "repeat"
  "for"
] @keyword.control.loop.r

[
  (true)
  (false)
] @constant.language.boolean.r

[
  (null)
  (inf)
  (nan)
  (na)
  (dots)
  (dot_dot_i)
] @constant.language.r

; Error

(ERROR) @invalid.illegal.r
