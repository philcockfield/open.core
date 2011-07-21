global.color =
    bold  : "\033[0;1m"
    red   :"\033[0;31m"
    green : "\033[0;32m"
    reset : "\033[0m"


module.exports =
  javascript: require './javascript'
  send:       require './send'
  fs:         require './fs'
  cake:       require './cake'
  git:        require './git'

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
  Renders the specified template from the 'views' path.
  @param response object to write to.
  @param template: path to the template within the 'views' folder.
  @param options: variables to pass to the template.
  ###
  render: (response, template, options) ->
          core = require 'core.server'
          extension = options.extension ?= 'jade'
          options.baseUrl ?= core.baseUrl
          response.render "#{core.paths.views}/#{template}.#{extension}", options



