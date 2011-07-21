fs = require 'fs'

# ANSI Terminal Colors.
global.color =
  bold  : "\033[0;1m"
  red   : "\033[0;31m"
  green : "\033[0;32m"
  reset : "\033[0m"


packagePath = (packageDir) -> "#{packageDir}/package.json"


module.exports =

  ###
  Logs a message to the console optionally with a color.
  @param message      : to write to the console.
  @param color        : (optional) the color to use.  Omit for standard (black).  See [global.color]
  @param explanation  : (optional) follow on text written in black.
  ###
  log: (message, color, explanation) ->
      if message?
        explanation ?= ''
        console.log "#{color}#{message}#{global.color.reset} #{explanation}"
      else
        console.log ''


  ###
  Default handler after the 'exec' command it invoked.
  Prints output to console and exits process if failed.
  @param err    : the error (if any).
  @param stdout : the standard out.
  @param stderr : the standard error.
  ###
  onExec: (err, stdout, stderr) ->
    console.log stdout if stdout
    console.log stderr if stderr
    # print the err message and kill the process
    if err?
        process.stdout.write "#{red}#{err.stack}#{reset}\n"
        process.exit -1


  ###
  Gets the package.json in the given directory
  @param dir: The directory the [package.json] file is in.
  ###
  readPackage: (dir) ->
      path = packagePath(dir)
      data = fs.readFileSync path, 'utf8'
      JSON.parse data.toString()

  ###
  Saves the given package to disk.
  @param package : {object} The package JSON.
  @param dir     : the directory of the package.
  ###
  savePackage: (package, dir) ->
      str = JSON.stringify(package, null, '\t')
      fs.writeFileSync packagePath(dir), str, 'utf8'


