CORE_PATH = 'open.client/core'

module.exports = 
  using: (module) -> require "#{CORE_PATH}/mvc/#{module}"
  util: require "#{CORE_PATH}/util"

  ###
  Provides common callback functionality for executing sync (server) method.
  @param fnSync       : The Backbone function to execute (eg. Backbone.Model.fetch).
  @param source       : The source object that is syncing.
  @param methodName   : The name of the sync method (eg. 'fetch').
  @param options      : The options passed to the method (contains success/error callbacks).
  ###
  sync: (fnSync, source, methodName, options = {}) -> 
      fire = (event, args) -> source[methodName].trigger event, args
      onComplete = (response, success, error, callback) -> 
              args = 
                  source:   source
                  response: response
                  success:  success
                  error:    error
              fire 'complete', args
              callback?(args)

      # Execute the method, with callbacks to the standard response handler.
      fire 'start', source:source
      fnSync.call source,
            success: (m, response) -> onComplete(response, true, false, options.success)
            error:   (m, response) -> onComplete(response, false, true,  options.error)
    