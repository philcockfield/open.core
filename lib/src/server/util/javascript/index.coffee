minifier = require './minifier'

module.exports = index =
  minifier:   minifier
  
  # Methods
  compress:   minifier.compress
  
  # Classes
  Builder:            require './build/builder'
  BuildPath:          require './build/build_path'
  BuildFile:          require './build/build_file'


_.extend index, require './_common'
