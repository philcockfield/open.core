minifier = require './minifier'

module.exports =
  minifier: minifier
  compress: minifier.compress
