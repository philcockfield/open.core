require('./config/libs')
config = require './config/config'

module.exports =
  title:  'Open.Core (Server)'
  paths:  require './config/paths'
  util:   require './util/util'


  ###
  Configures the TestHarness
  @param options:
          - baseUrl: The base URL path to put the TestHarness within (default: /testharness).
  ###
  configure: (app, options = {}) ->
        @baseUrl = options.baseUrl ?= '/core'
        @app = app
        config @, options
