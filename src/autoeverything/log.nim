import common, output
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

proc logException*(dirname, pkgname, msg: string) =
  info "Writing system exception for package ", pkgname
  let
    jsonname = makeJSONFile(dirname, pkgname, time)
    logname = makeExceptionLogFile(dirname, pkgname, time)

  if jsonname == "" or logname == "":
    info "Showstopping error has occured, quitting so someone can fix it."
    quit(1)

  try:
    writeFile(logname, msg)
    writeFile(jsonname, toString(Exception, newOutputForException(pkg)))
  except CatchableError as err:
    info "Couldn't save log files: ", err.msg

proc logInstall*(dirname: string, output: Output, success: string) =
  info "Writing install log for package ", output.package, " (", success ,")"

  let
    jsonname = makeJSONFile(dirname, output.package, output.date)
    logname = makeLogFile(dirname, output.package, output.date)
  
  if jsonname == "" or logname == "":
    info "Showstopping error has occured, quitting so someone can fix it."
    quit(1)

  try:
    writeFile(logname, output.output)
    writeFile(jsonname, $output)
  except CatchableError as err:
    info "Couldn't save log files: ", err.msg

proc logInstallFail*(dirname: string, output: Output) = logInstall(dirname, output, "Success")
proc logInstallSuccess*(dirname: string, output: Output) = logInstall(dirname, output, "Fail")