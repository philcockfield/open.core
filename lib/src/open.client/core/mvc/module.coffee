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
      
      # Setup initial conditions.
      req = @require
      
      # Construct MVC index.
      do => 
          get      = Module.requirePart
          getIndex = (fnRequire) ->  
                            index = get(fnRequire, '')
                            index ?= {}
          models      = getIndex req.model
          views       = getIndex req.view
          controllers = getIndex req.controller
      
          # Assign conventional views (if they exist).
          getView = (name) -> get req.view, name
          views.Root = getView 'root' unless views.Root?
          views.Tmpl = getView 'tmpl' unless views.Tmpl?
          
          # Assign as properties.
          @models      = models
          @views       = views
          @controllers = controllers
      
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
    
    # Silently try to get the module.
    part = fnRequire name, throw: false
    return part unless part?
    
    # If the [part] is a funciton, it is expected that this is an initialization
    # function.  Invoke it passing in the module.
    # Perform this within a try-catch block, because if it is just exporting a class
    # then invoking the function will fail.
    try
        part = part(fnRequire.module) if _.isFunction(part)
    catch error
        # Ignore - was an exported class only
        # Did not implement the module-init pattern.
      
    
    # Finish up.
    part
    


# EXPORT
module.exports = Module

