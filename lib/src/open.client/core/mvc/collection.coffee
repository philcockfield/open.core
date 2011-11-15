common = require './_common'

###
Base class for Collections.

Events:
 - change           : Fires when a property on a model in the collection changes.
 - add              : Fires when an item is added to the collection.
 - remove           : Fires when an item is removed.
 - count            : Fires when an item is either added or removed.

###
module.exports = class Collection extends Backbone.Collection
  constructor: () -> Collection::_construct.call @
  
  ###
  Called internally by the constructor.  
  Use this if properties are added to the object after 
  construction and you need to re-run the constructor,
  (eg. within a functional inheritance pattern).
  ###
  _construct: () -> 
      Collection.__super__.constructor.call @
      _.extend @fetch, Backbone.Events
      
      fireCount = (col) => @trigger 'count', length:@length
      
      # Wire up events.
      @bind 'add', fireCount
      @bind 'remove', fireCount
  
  
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


