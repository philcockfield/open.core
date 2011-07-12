###
Common base class.
###
module.exports = class Base
  constructor: ->
          # Enable eventing.
          _.extend @, Backbone.Events


  ###
  Common utility functionality for the class.
  ###
  util:
    # Merges the properties from the source object onto the target object.
    # @returns: The target object.
    #
    # Example: Use this in a constructor to merge 'params' with more parameter
    #          values that you are passing up to the base class via 'super':
    #
    #           class MyClass extends Base
    #             constructor: (params) ->
    #                 super @util.merge params, { myParam: 1234 }
    #
    merge: (source, target) -> _.extend target ?= {}, source ?= {}
