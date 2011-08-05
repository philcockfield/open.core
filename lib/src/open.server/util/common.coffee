client = require 'open.client/core'

# Store color in global namespace.
global.color =
    bold   : "\033[0;1m"
    grey   : "\033[0;30m"
    red    : "\033[0;31m"
    green  : "\033[0;32m"
    yellow : "\033[0;33m"
    blue   : "\033[0;34m"
    pink   : "\033[0;35m"
    cyan   : "\033[0;36m"
    reset  : "\033[0m"

log = (message, color, explanation) ->
        color = '' unless color?
        if message?
          explanation ?= ''
          console.log "#{color}#{message}#{global.color.reset} #{explanation}"
        else
          console.log ''

module.exports =
  # Client aliases.
  toBool: client.util.toBool

  ###
  Logs a message to the console optionally with a color.
  @param message      : to write to the console.
  @param color        : (optional) the color to use.  Omit for standard (black).  See [global.color]
  @param explanation  : (optional) follow on text written in black.
  ###
  log: log

  ###
  Renders the specified template from the 'views' path.
  @param response   : object to write to.
  @param template   : path to the template within the 'views' folder.
  @param options    : variables to pass to the template.
  ###
  render: (response, template, options = {}) ->
          core = require 'open.server'
          extension = options.extension ?= 'jade'
          options.baseUrl ?= core.baseUrl
          response.render "#{core.paths.views}/#{template}.#{extension}", options

  ###
  Default handler after the invoked 'exec' command.
  Prints output to console and exits process if failed.
  @param err    : the error (if any).
  @param stdout : the standard out.
  @param stderr : the standard error.
  ###
  onExec: (err, stdout, stderr) ->
    console.log stdout if stdout
    log(stderr, color.red) if stderr
    # Write the err message and kill the process.
    if err?
        process.stdout.write "#{color.red}#{err.stack}#{color.reset}\n"
        process.exit -1
