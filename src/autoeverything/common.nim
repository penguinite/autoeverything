import std/[times, strutils, os]
import iniplus

const version*{.strdefine.} = "0.1.0"

# Thanks https://hookrace.net/blog/introduction-to-metaprogramming-in-nim/#logger
template info*(str: varargs[string, `$`]) =
  stdout.writeLine("[$# $#]($#:$#): $#" % [getDateStr(), getClockStr(), instantiationInfo().filename, $instantiationInfo().line, str.join])

template error*(str: varargs[string, `$`]) =
  info(str)
  quit(1)

type
  Config* = object
    logsDir*, exceptionsDir*: string
  
proc getConfig*(): Config =
  var file = "app.conf"
  if existsEnv("AUTOEVERYTHING_CONFIG"):
    file = getEnv("AUTOEVERYTHING_CONFIG")
  
  let config = parseString(readFile(file))
  result.logsDir = config.getStringOrDefault("folders","logsDir","logs")
  result.exceptionsDir = config.getStringOrDefault("folders","exceptionsDir","exceptions")