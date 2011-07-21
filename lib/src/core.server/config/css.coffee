stylus  = require 'stylus'
paths   = require './paths'
nib     = require 'nib'

# Setup CSS (with references to QUI).
module.exports =
  configure: (use) ->
      compile = (str, path) ->
          stylus(str)
              .use(nib())
      use stylus.middleware
              src:     paths.public
              compile: compile

