###
Model: Represents an "it" specification.
###
module.exports = (module) ->
  class Spec extends module.mvc.Model
    defaults:
        description:  null
        func:         null

    ###
    Constructor.
    @param params:  The array of arguments retreived from the describe function.
    @param suite:   The suite that the spec belongs to.
    ###
    constructor: (params = {}, @suite) -> 
        
        # Setup initial conditions.
        super
        params = [params] unless _(params).isArray()
        first  = _(params).first()
        last   = _(params).last()
        
        # Store parts.
        @description first if _(first).isString()
        @func last if _(last).isFunction()
    
    
    ###
    Invokes the spec.
    ###
    invoke: -> 
        
        # Invoke the [beforeEach] method(s).
        # This starts at the root most ancestor suite and works down to the this (the closest) suite.
        _(@suite.ancestors(direction:'descending')).each (suite) -> 
              suite.beforeEach.each (op) -> op.invoke()
        
        # Invoke the spec.
        try
          fn = @func()
          fn?()
        catch error
          if console?
              console.log 'Failed to invoke spec.' 
              console.log ' - describe: ', @suite.title()
              console.log '         it: ', @description()
              module.logError error
              console.log ''
        
        # Invoke the [afterEach] method(s).
        # This starts at the this (the closest) suite and works out to the most distant ancestor suite.
        _(@suite.ancestors(direction:'ascending')).each (suite) -> 
              suite.afterEach.each (op) -> op.invoke()
  
  
  # Collection.
  class Spec.Collection extends module.mvc.Collection
    model: Spec
  
  
  # Export.
  Spec

