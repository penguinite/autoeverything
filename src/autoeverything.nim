import autoeverything/[download, common]
import std/[json, os]

var packages{.threadvar.}: JsonNode

proc reloadPkgs() =
  if not fileExists("packages.json") and not savePkgList():
    info "Couldn't save packages.json"
  packages = parseJson(getPkgList())

