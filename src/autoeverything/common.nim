import std/[times, strutils]

# Thanks https://hookrace.net/blog/introduction-to-metaprogramming-in-nim/#logger
template info*(str: varargs[string, `$`]) =
  stdout.writeLine("[$# $#]($#:$#): $#" % [getDateStr(), getClockStr(), instantiationInfo().filename, $instantiationInfo().line, str.join])

template error*(str: varargs[string, `$`]) =
  info(str)
  quit(1)