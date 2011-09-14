using = (module) -> require 'open.client/core/' + module
Base     = using 'base'
common   = using '/mvc/_common'
util     = using 'util'

class Module extends Base
  tryRequire: util.tryRequire
  
  ###
  Constructor.
  @param modulePath: The path to the module.
  ###
  constructor: (@modulePath) -> 
      super
      _require = (dir) => 
          
          # Require statement scoped within the given directory.
          requirePart = (name = '', options = {}) => 
              options.throw ?= true
              @tryRequire "#{@modulePath}/#{dir}/#{name}", options
          
          # Store reference to the module on the [require] function.
          requirePart.module = @
          requirePart
          
      # Store [require] part functions.
      @require = 
          model:      _require 'models'
          view:       _require 'views'
          controller: _require 'controllers'

  
  ###
  The root view of the module (convention).
  When overriding the Module, set this property convention based proeprty within Init.
  ###
  rootView: null
  
  ###
  An index of the convention based MVC structures within the module.
  The object has the form:
    - models
    - views
    - controllers
  ###
  index: null # Set in Init method.
  
  ###
  An index of helper methods for requiring sub-modules within the MVC folder structure of the module.
  This is an index of functions:
     - model
     - view
     - controller
  
  For example, to retrieve a module named 'foo' within the /models folder:
      foo = module.require.model('foo')
  ###    
  require: null # Set in constructor.
  
  ###
  Initializes the module (overridable).
  @param options
          - within: The CSS selector, DOM element, JQuery Object or [View] to initialize 
                    the module wihtin.  Passing 'options' param through the base 'init' method
                    converts whatever type of value to a jQuery element.
  ###
  init: (options = {}) -> 
      
      # Construct MVC index.
      get = Module.requirePart
      @index =
          models:      get @require.model
          views:       get @require.view
          controllers: get @require.controller
  
      # Translate [within] option to jQuery object.
      options.within = util.toJQuery(options.within)


# STATIC METHODS

###
Attempts to get an MVC part using the given require function - 
invoking it as a module init if it's a function
CONVENTION: 
    If the index returns a function, rather than a simple object-literal
    the module assumes it wants to be initialized with this, the parent module
    and invokes it passing the module as the parameter.

@param fnRequire: The require-part function (see module.require.*)
@param name:      The name of the module.  Default is [index] (empty string).
@returns the module or null if the MVC part does not exist.
###
Module.requirePart = (fnRequire, name = '') -> 
    
    # Silently try to get the 'index' of the MVC part.
    index = fnRequire name, throw: false
    return index unless index?
    
    # If the [index] is a funciton, it is expected that this is an initialization
    # function.  Invoke it passing in the module.
    index = index(fnRequire.module) if _.isFunction(index)
    
    # Finish up.
    index
    


# EXPORT
module.exports = Module

