
## Line by line parser for parsing nimble output.
## The most complex parts (such as urls) are parsed character by character.

import std/[json, times]

type
  OperationKind* = enum
    Install, Exception
  OutputKind* = enum
    Success, Failure, HostError

  Output* = object of RootObj
    kind*: OutputKind
    package*: string
    date*: DateTime
    output*: string

proc parseNimbleOutput*(output: string, pkg: string, date: DateTime = now()): Output =
  result.package = pkg
  result.date = date
  return result

proc newOutputForException*(pkg: string, date: DateTime = now()): Output =
  result.package = pkg
  result.date = date
  result.kind = Failure

proc fromStringOper*(s: string): OperationKind =
  case s:
  of "Install": return Install
  of "Exception": return Exception

proc `$`*(k: OperationKind): string =
  case k:
  of Install: return "Install"
  of Exception: return "Exception"

proc fromString*(s: string): OutputKind =
  case s:
  of "Failure": return Failure
  of "HostError": return HostError
  of "Success": return Success

proc `$`*(k: OutputKind): string = 
  case k:
  of Failure: return "Failure"
  of HostError: return "HostError"
  of Success: return "Success"

proc toString*(k: OperationKind, o: Output, logname: string): string =
  return $(%*[{
    "kind": $k,
    "pkg": o.package,
    "result": $(o.kind),
    "date": $(o.date),
    "log_fn": logname
  }])

proc fromString(s: string): (OperationKind, Output, string) =
  # First string is kind ()
  return