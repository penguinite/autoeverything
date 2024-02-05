# Package

version       = "0.1.0"
author        = "penguinite"
description   = "Every nimble package ever... Now in one convenient automated package!"
license       = "CC0"
srcDir        = "src"
bin           = @["autoeverything"]
binDir      = "build"

# Dependencies

requires "nim >= 2.0.0"
requires "iniplus"