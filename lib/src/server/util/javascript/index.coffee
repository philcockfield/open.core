minifier = require './minifier'

module.exports =
  minifier:   minifier
  compress:   minifier.compress
  Compiler:   require './compiler'
  build:      require './build'
