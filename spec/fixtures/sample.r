# Assertions live in the comments: `<- scope` checks the marker's own column
# on the previous non-comment line, `^ scope` checks the caret's. Scopes
# match by prefix, so the trailing `.r` segment is left off.

f <- function(x, y) {
#    ^ storage.type.function
#            ^ punctuation.definition.arguments.begin.bracket.round
#              ^ punctuation.separator.comma
#                   ^ punctuation.definition.block.begin.bracket.curly

  z <- x + 2
#          ^ constant

  s <- "text"
#       ^ string

}
# <- punctuation.definition.block.end.bracket.curly

# a comment
# <- comment
