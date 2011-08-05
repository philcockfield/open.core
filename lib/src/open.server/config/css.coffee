stylus  = require 'stylus'
nib     = require 'nib'
paths   = require './paths'

# Setup CSS (with references to Core).
module.exports =
  configure: (use) ->
      compile = (str, path) ->
          stylus(str).use(nib())
      use stylus.middleware
              src:     paths.public
              compile: compile

