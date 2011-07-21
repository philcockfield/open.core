fs = require 'fs'

packagePath = (packageDir) -> "#{packageDir}/package.json"

module.exports =
  version: require './version'

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



