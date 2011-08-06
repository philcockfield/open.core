minifier = require './minifier'

module.exports =

  # Index
  minifier:   minifier
  build:      require './build'

  # Methods
  compress:   minifier.compress

  # Classes
  Compiler:         require './compiler'