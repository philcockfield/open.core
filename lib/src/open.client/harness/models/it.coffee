###
Model: Represents an "it" specification.
###
module.exports = (module) ->
  class It extends module.mvc.Model
    defaults:
        description:  null
        func:         null

    ###
    Constructor.
    @param params: The array of arguments retreived from the describe function.
    ###
    constructor: (params) -> 
        
        # Setup initial conditions.
        super
        params = [params] unless _(params).isArray()
        first = _(params).first()
        last = _(params).last()
        
        # Store parts.
        @description first if _(first).isString()
        @func last if _(last).isFunction()
  
  
  
  # Collection.
  class It.Collection extends module.mvc.Collection
    model: It
  
  
  # Export.
  It

