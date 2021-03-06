stylus  = require 'stylus'
nib     = require 'nib'
paths   = require './paths'

# Setup CSS (with references to Core).
module.exports =
  configure: (use) ->
      compile = (str, path) ->
          stylus(str)
              .include(paths.public)
              .include(paths.stylesheets)
              .include("#{paths.stylesheets}/core")
              .include("#{paths.stylesheets}/core/controls")
              .include("#{paths.stylesheets}/core/controls/buttons")
              .include("#{paths.stylesheets}/core/modules")
              .include("#{paths.stylesheets}/dev")
              .use(nib())
      use stylus.middleware
              src:     paths.public
              compile: compile

