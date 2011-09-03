minifier = require './minifier'

module.exports =

  # Index
  minifier:   minifier
  build:      require './build'

  # Methods
  compress:   minifier.compress

  # Classes
  Compiler:         require './compiler'
  Builder:          require './build/builder'
  BuildPath:        require './build/build_path'
  BuildFile:        require './build/build_file'
