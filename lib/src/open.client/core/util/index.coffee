using = (module) -> require 'open.client/core/util/' + module
using 'jquery' # Load jQuery extensions.

util =
  Property:   using 'property'

  ###
  Executes a [require] call within a try/catch block.
  @param path : Path to the require statement.
  @param options
            - throw: Flag indicating if the errors should be thrown (default: false)
            - log:   Flag indicating if errors should be written to the console (default: false)
  ###
  tryRequire: (path, options = {}) -> 
    throwOnError = options.throw ?= false
    log = options.log ?= false
    try
        window.require path
    catch error
        throw error if throwOnError
        console?.log '[tryRequire] Failed to load module: ' + path if log
    


# Export
_.extend util, using('_conversion')
module.exports = util
