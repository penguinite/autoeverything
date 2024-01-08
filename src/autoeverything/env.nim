import iniplus, std/os

const version*{.strdefine.} = "0.1.0"

func getConfig*(): string =
  result = "app.conf"
  if existsEnv("AUTOEVERYTHING_CONFIG"):
    result = getEnv("AUTOEVERYTHING_CONFIG")
  return result

func getInput*(config: ConfigTable): string =
  return config.getStringOrDefault("","input","")

func getUseragent*(config: ConfigTable): string =
  result = "AutoEverything " & version
  if config.exists("web","identifier"):
    result.add("(" & config.getString("web","identifier") & ")")
  return result

func getOutput*(config: ConfigTable): string =
  return config.getStringOrDefault("","input","logs.json")