import common
import std/[os, times, json]

proc makeFile*(dirname, pkgname, ext: string, time: DateTime): string =
  let pkgfolder = dirname & "/" & pkgname
  var filename = dirname & "/" & pkgname & "/" & $time & ext
  try:
    if not dirExists(dirname): createDir(dirname)
    if not dirExists(pkgfolder): createDir(pkgfolder)
    if not fileExists(filename): writeFile(filename, "")
    else:
      # Enter a loop to find out a filename that isn't taken.
      var i = 0
      while true:
        inc(i)
        filename.add("-" & $i)
        if not fileExists(filename):
          writeFile(filename, "")
          break
        filename = filename[0..^3]
    return filename
  except:
    info "Couldn't write \"", filename, "\""
    return ""

proc makeJSONFile*(dirname: string, pkgname: string, time: DateTime): string = return makeFile(dirname, pkgname, ".json", time)
proc makeLogFile*(dirname: string, pkgname: string, time: DateTime): string = return makeFile(dirname, pkgname, ".log", time)
proc makeExceptionLogFile*(dirname: string, pkgname: string, time: DateTime): string = return makeFile(dirname, pkgname, "-exception.log", time)

proc logException*(dirname, pkgname, msg: string, time: DateTime = now()) =
  info "Writing system exception for package ", pkgname
  let
    jsonname = makeJSONFile(dirname, pkgname, time)
    logname = makeExceptionLogFile(dirname, pkgname, time)

  if jsonname == "" or logname == "":
    info "Showstopping error has occured, quitting so someone can fix it."
    quit(1)

  try:
    writeFile(logname, msg)
    writeFile(jsonname, $(%*[{"kind": "exception","pkg": pkgname,"time": $time,"log": logname}]))
  except CatchableError as err:
    info "Couldn't save log files: ", err.msg

proc logInstall*(dirname, pkgname, output: string, success: bool, time: DateTime = now()) =
  var tmp = "failed"
  if success: tmp = "success"
  info "Writing ", tmp, " install log for package: ", pkgname
  let
    jsonname = makeJSONFile(dirname, pkgname, time)
    logname = makeLogFile(dirname, pkgname, time)
  
  if jsonname == "" or logname == "":
    info "Showstopping error has occured, quitting so someone can fix it."
    quit(1)

  try:
    writeFile(logname, output)
    writeFile(jsonname, $(%*[{"kind":"install","pkg":pkgname,"time": $time,"success":success,"log":logname}]))
  except CatchableError as err:
    info "Couldn't save log files: ", err.msg

proc logInstallFail*(dirname, pkgname, output: string, time: DateTime = now()) = logInstall(dirname, pkgname, output, false, time)
proc logInstallSuccess*(dirname, pkgname, output: string, time: DateTime = now()) = logInstall(dirname, pkgname, output, true, time)