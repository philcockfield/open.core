require './_string'  # Cause string extensions to be loaded (added to underscore.string).

module.exports = util =
  Property: require './property'
  jQuery:   require './_jquery'   # NB: Also causees jQuery extensions to be loaded.

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
    


# Extend with partial modules.
_.extend util, require './_conversion'
