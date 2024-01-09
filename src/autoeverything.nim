import autoeverything/[download, common, env]
import std/[json, os, osproc]
import iniplus, weave


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

proc uninstallPkg*(pkg: string) =
  info "Uninstalling ", pkg
  discard execProcess("nimble -y uninstall " & pkg)

proc quickDirExists*(pkg: string) =
  let nimbleDir = 

while true:
  # Reload packages.json
  info "Re-downloading packages list"
  packages = parseJson(downloadPkgList())
  
  info "Uninstalling all packages"
  for package in packages:
    if not package.contains("name") or not package.contains("url"):
      continue # Skip, its probably an alias or some weird mess.
    init(Weave)
    uninstallPkg(package["name"].getStr())
    exit(Weave)

  for package in packages:
    if not package.contains("name") or not package.contains("url"):
      continue # Skip, its probably an alias or some weird mess.
    init(Weave)
    spawn processPkg(package["name"].getStr())
    exit(Weave)
# And we are gone....