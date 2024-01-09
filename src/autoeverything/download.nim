{.define: ssl.}

import std/[httpclient, os, strutils]

const packages_lists* = @[
  "https://raw.githubusercontent.com/nim-lang/packages/master/packages.json",
  "https://nim-lang.org/nimble/packages.json"
]

proc basicDownload(url: string): string =
  let client = newHttpClient()
  try:
    result = client.getContent(url)
    if result.isEmptyOrWhitespace():
      return ""
    return result
  except:
    return ""
  finally:
    client.close()

proc downloadPkgList*(): string =
  for url in packages_lists:
    result = basicDownload(url)
    if result != "":
      break
  
  return result

proc getPkgList*(): string =
  if fileExists("packages.json"):
    return readFile("packages.json")
  result = downloadPkgList()
  return result

proc savePkgList*(): bool {.discardable.} =
  try:
    writeFile("packages.json", getPkgList())
    return true
  except:
    return false