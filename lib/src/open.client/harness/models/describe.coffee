###
Model: Represents a specifications 'describe' block.
###
module.exports = (module) ->
  class Describe extends module.mvc.Model
    defaults:
        title:    null
        summary:  null
        func:     null
    
    ###
    Constructor
    @param params: The array of arguments retreived from the describe function.
    ###
    constructor: (params) -> 
        super
        params = [params] unless _(params).isArray()
        last = _(params).last()
        
        # Store parts.
        @title params[0]
        @summary params[1] if _(params[1]).isString()
        @func last if _(last).isFunction()
  
  
  # Collection.
  Describe.Collection = class Describe.Collection extends module.mvc.Collection
    model: Describe
  
  # Export.
  Describe
  



  