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
      
      # Setup initial conditions.
      throw 'Module path not specified' if not @modulePath? or _.isBlank(@modulePath)
      super
        
      # Setup the module part [require] functions.
      req = (dir) => 
          
          # Curry function. Require statement scoped within the given directory.
          requirePart = (name = '', options = {}) => 
              # Retrieve the module.
              options.throw ?= true
              part = @tryRequire "#{@modulePath}/#{dir}/#{name}", options
              
              # Invoke the [module-init] pattern if required.
              if part? and options.init ?= false
                  part = Module.initPart @, part
              
              # Finish up.
              part
          
          # Store reference to the module on the [require] function.
          requirePart.module = @
          requirePart
      
      # Store [require] part functions as director properties structure.
      @model      = req 'models'
      @view       = req 'views'
      @controller = req 'controllers'

      # Store [require] part functions as object structure.
      @require = 
          model:      @model
          view:       @view
          controller: @controller


  
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
  An index of the module-part require functions:
    - model
    - view
    - controller
  
  Each MVC function takes the parameters:
  
  @param name: The name of the module (folder).
  @param options
            - init:  Flag indicating if the [parent module-init] pattern should be invoked (default: false)
            - throw: Flag indicating if the errors should be thrown (default: false)
            - log:   Flag indicating if errors should be written to the console (default: false)
  
  For example, to retrieve a module named 'foo' within the /models folder:
      foo = module.require.model('foo')
      
        or
      
      foo = module.model('foo')
  ###    
  require: null # (Set in constructor)

  # A require function scoped to retrieve [Models] within the module. (see 'require.*' method comments for more).
  model: null      # (Set in constructor)
  
  # A require function scoped to retrieve [Views] within the module. (see 'model' method comments for more).
  view: null       # (Set in constructor)
  
  # A require function scoped to retrieve [Controllers] within the module. (see 'model' method comments for more).
  controller: null # (Set in constructor)
  
  
  ###
  Initializes the module (overridable).
  @param options
          - within: The CSS selector, DOM element, JQuery Object or [View] to initialize 
                    the module wihtin.  Passing 'options' param through the base 'init' method
                    converts whatever type of value to a jQuery element.
  ###
  init: (options = {}) -> 
      
      # Translate [within] option to jQuery object.
      options.within = util.toJQuery(options.within)
      
      # Construct MVC index.
      req = @require
      do => 
          get = Module.requirePart
          
          # Assign as properties (don't overwrite an existing property).
          setIndex = (propName, fnRequire) => 
                  return if @[propName]?
                  getIndex = (fnRequire) ->  
                                  index = get(fnRequire, '')
                                  index ?= {} # Empty object representing [index] if there was no module.
                  @[propName] = getIndex fnRequire
          
          setIndex 'models',      @model
          setIndex 'views',       @view
          setIndex 'controllers', @controller
          
          # Assign conventional views (if they exist).
          setView = (prop, name) => 
                        return if @views[prop]? # View has already been setup.
                        view = get req.view, name
                        @views[prop] = view if view? # Only assign the property if the view was found.
          setView 'Root', 'root'
          setView 'Tmpl', 'tmpl'
          


# STATIC METHODS

###
Attempts to get an MVC part using the given require function - 
invoking it as a module init if it's a function
CONVENTION: 
    If the index returns a function, rather than a simple object-literal
    the module assumes it wants to be initialized with this, the parent module
    and invokes it passing the module as the parameter.

@param fnRequire: The require-part function 
                  (see [module.require.*] method)
@param name:      The name of the module.  Default is [index] (empty string).
@returns the module or null if the MVC part does not exist.
###
Module.requirePart = (fnRequire, name = '') -> 
    
    # Silently try to get the module.
    part = fnRequire name, throw: false
    return part unless part?

    # If the [part] is a function, it is expected that this is an initialization function.
    # Invoke it passing in the module.
    part = Module.initPart(fnRequire.module, part)

    # Finish up.
    part
    

###
Implements the parent [module-init] pattern.
@param parentModule: The parent module.
@param childModule: The child module to initialize.
###
Module.initPart = (parentModule, childModule) -> 
    # Perform this within a try-catch block, because if it is just exporting a class
    # then invoking the function will fail.
    try
        childModule = childModule(parentModule) if _.isFunction(childModule)
    catch error
        # Ignore - was an exported class only
        # It did not implement the module-init pattern.
    childModule



# EXPORT
module.exports = Module

