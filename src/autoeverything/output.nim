
## Line by line parser for parsing nimble output.
## The most complex parts (such as urls) are parsed character by character.


type
  OutputKind* = enum
    Success, Failure, HostError
  Output* = case

