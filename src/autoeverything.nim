import autoeverything/[download, common, log]
import std/[json, os, osproc, strutils]

when defined(windows):
  {.warn: "This project hasn't been tested on Windows unfortunately. Feel free to open a report if there's a bug somewhere.".}

let config = getConfig()
var packages: JsonNode = parseJson(downloadPkgList())

proc logPkg*(failed: bool, name: string, log: string)  =
  return

proc processPkg*(pkg: string) =
  for kind, path in walkDir(getHomeDir() & ".nimble/pkgs2/"):
    if kind != pcDir: continue
    if split(path[len(getHomeDir() & ".nimble/pkgs2/")..^1],"-")[0] == pkg:
      removeDir(path)
  try:
    let output = execProcess("nimble -y install " & pkg)
    if "Failed" in output or "failed" in output:
      logInstallFail(config.logsDir, pkg, output)
    else:
      logInstallSuccess(config.logsDir, pkg, output)
  except CatchableError as err:
    logException(config.exceptionsDir, pkg, err.msg)
  return

echo "autoeverything v", version
echo "Copyright (c) penguinite 2024"
info "Starting up the automatron"

proc isNimbleDirEmpty*(): bool =
  var i = 0
  for kind, path in walkDir(getHomeDir() & ".nimble/pkgs2/"):
    # Skip if not dir.
    if kind != pcDir: continue
    inc i
  
  if i > 0: return false
  else: return true


while true:
  # Reload packages.json
  info "Re-downloading packages list"
  packages = parseJson(downloadPkgList())
  
  # Test every package
  for package in packages:
    if not package.contains("name") or not package.contains("url"):
      continue # Skip, its probably an alias or some weird mess.
    processPkg(package["name"].getStr())
    
# And we are gone....