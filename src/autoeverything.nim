import autoeverything/[download, common, env]
import std/[json, os, osproc, strutils]
import iniplus, malebolgia

when defined(windows):
  {.warn: "This project hasn't been tested on Windows unfortunately. Feel free to open a report if there's a bug somewhere.".}

let config: ConfigTable = iniplus.parseFile(getConfig())
var packages: JsonNode = parseJson(downloadPkgList())

proc logPkg*(failed: bool, name: string, log: string)  =
  return

proc processPkg*(pkg: string) =
  info "Testing ", pkg
  let output = execProcess("nimble -y install " & pkg)
  echo output
  return

echo "autoeverything v", version
echo "Copyright (c) systemonia 2024"
info "Starting up the automatron"

proc isNimbleDirEmpty*(): bool =
  var i = 0
  for kind, path in walkDir(getHomeDir() & ".nimble/pkgs2/"):
    # Skip if not dir.
    if kind != pcDir: continue
    inc i
  
  if i > 0: return false
  else: return true

proc nukeNimbleDir*() =
  for kind, path in walkDir(getHomeDir() & ".nimble/pkgs2/"):
    # Skip if not dir.
    if kind != pcDir: continue
    info "Nuking ", split(path[len(getHomeDir() & ".nimble/pkgs2/")..^1],"-")[0]
    removeDir(path)



while true:
  # Reload packages.json
  info "Re-downloading packages list"
  packages = parseJson(downloadPkgList())

  # Nuke packages.json
  while isNimbleDirEmpty() == false:
    info "Nuking nimble directory..."
    nukeNimbleDir()
  
  # Test every package
  for package in packages:
    if not package.contains("name") or not package.contains("url"):
      continue # Skip, its probably an alias or some weird mess.
    processPkg(package["name"].getStr())
    
# And we are gone....