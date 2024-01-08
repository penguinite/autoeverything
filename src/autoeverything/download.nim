{.define: ssl.}

import std/[httpclient, streams, os]

const packages_lists* = @[
  "https://raw.githubusercontent.com/nim-lang/packages/master/packages.json",
  "https://nim-lang.org/nimble/packages.json"
]

proc basicDownload(url: string): string =
  let client = newHttpClient()
  try:
    let response = client.get(url)

    if response[].status != "200":
      return ""

    return response[].bodyStream.readAll()
  except:
    return ""
  finally:
    client.close()

proc getPkgList*(): string =
  if fileExists("packages.json"):
    return readFile("packages.json")

  for url in packages_lists:
    result = basicDownload(url)
    if result != "":
      break
  
  return result

proc savePkgList*(): bool {.discardable.} =
  try:
    writeFile("packages.json", getPkgList())
    return true
  except:
    return false