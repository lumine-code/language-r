# language-r

R language support.

## Features

- **Grammars**: provides Tree-sitter grammars, built from [tree-sitter-r](https://github.com/r-lib/tree-sitter-r).
- **Syntax highlighting**: functions, formulas, the assignment and pipe operators, and both subsetting forms.
- **Subsetting**: `[` and `[[` are scoped apart, since one slices and the other extracts.
- **Symbol navigation**: function definitions and assignments.
- **Locals**: resolves parameters and local bindings.

## Installation

To install `language-r` search for _language-r_ in the Install pane of the Lumine settings or run `lumine --install lumine-code/language-r`.

## Services

- **hyperlink.injection** (`^1.0.0`): consumed to highlight URLs in these files as clickable links.
- **todo.injection** (`^1.0.0`): consumed to highlight `TODO`-style markers inside comments.

## Contributing

Got ideas to make this package better, found a bug, or want to help add new features? Just drop your thoughts on GitHub. Any feedback is welcome!
