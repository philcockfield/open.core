module.exports =
  javascript: require './javascript'
  send:       require './send'
  fs:         require './fs'

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
