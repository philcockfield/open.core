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
              .use(nib())
      use stylus.middleware
              src:     paths.public
              compile: compile

