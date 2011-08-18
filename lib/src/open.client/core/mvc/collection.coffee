common = require 'open.client/core/mvc/_common'

###
Base class for Collections.
###
module.exports = class Collection extends Backbone.Collection
  constructor: () -> 
      super
      _.extend @fetch, Backbone.Events

  ###
  Overrides the Backbone fetch method, enabling fetch events.
  @param options
          - error(args)   : (optional) Function to invoke if an error occurs.
          - success(args) : (optional) Function to invoke upon success.
                            Result args:
                              - collection  : The collection.
                              - response    : The response data.
                              - success     : {bool} Flag indicating if the operation was successful
                              - error       : {bool} Flag indicating if the operation was in error.
  ###
  fetch: (options) ->
      fetch = 'fetch'
      fn = Backbone.Collection.prototype[fetch]
      common.sync fn, @, fetch, options

  # Binds a handler to the fetch methods [complete] event.
  onFetched: (callback) -> @fetch.bind 'complete', callback if callback?

