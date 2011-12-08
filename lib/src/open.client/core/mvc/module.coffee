Base     = require '../base'
View     = require './view'
common   = require './_common'
util     = require '../util'

module.exports = Module = class Module extends Base
  tryRequire: util.tryRequire
  
  
  ###
  Constructor.
  @param module:     The CommonJS module (used to derive the path), or the path itself.
  @param properties: Optional. An object containing the property values to assign.
  ###
  constructor: (module, properties = {}) -> Module::_construct.call @, module, properties
  
  
  ###
  Called internally by the constructor.  
  Use this if properties are added to the object after 
  construction and you need to re-run the constructor,
  (eg. within a functional inheritance pattern).
  ###
  _construct: (module, properties = {}) -> 
      
      Module.__super__.constructor.call @
      _.extend @, Backbone.Events
      @addProps @defaults # Add defaults as Property functions.
      
      # Convenience properties.
      unless Module::core?
        core = require 'open.client/core'
        core.init()
        Module::core     = core
        Module::mvc      = core.mvc
      
      # Write property values passed into the constructor.
      if properties?
        for key of properties
          prop = @[key]
          prop properties[key] if (prop instanceof Function)
      
      # Derive the module path.
      if module?.id?
        # throw 'CommonJS module not specified' unless module.id?
        @modulePath = _(module.id).strLeftBack '/'
      else
        @modulePath = module
      if not @modulePath? or _.isBlank(@modulePath)
          throw 'Module path not specified. Pass either the path of the CommonJS module to [super].' 
      
      # Setup the module part [require] functions.
      req = (dir) => 
          
          # Curry function. Require statement scoped within the given directory.
          requirePart = (name, options = {}) => tryRequire @, dir, name, options
          
          # Store reference to the module on the [require] function.
          requirePart.module = @
          requirePart
      
      # Store [require] part functions as directory properties structure.
      @model      = req 'models'
      @view       = req 'views'
      @controller = req 'controllers'
      @collection = req 'collections'
      @util       = req 'utils'
      
      # Store [require] part functions as object structure.
      @require = 
          model:      @model
          view:       @view
          controller: @controller
          collection: @collection
          util:       @util
  
  
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
            - init:  Flag indicating if the [parent module-init] pattern should be invoked (default: true)
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
  
  # A require function scoped to retrieve [Views] within the module. (see 'require.*' method comments for more).
  view: null       # (Set in constructor)
  
  # A require function scoped to retrieve [Controllers] within the module. (see 'require.*' method comments for more).
  controller: null # (Set in constructor)
  
  # A require function scoped to retrieve [Collections] within the module. (see 'require.*' method comments for more).
  collection: null # (Set in constructor)
  
  
  ###
  Initializes the module (overridable).
  @param options
          - within: The CSS selector, DOM element, JQuery Object or [View] to initialize 
                    the module wihtin.  Passing 'options' param through the base 'init' method
                    converts whatever type of value to a jQuery element.
  ###
  init: (options = {}) -> 
      options.within = util.toJQuery(options.within) # Translate [within] option to jQuery object.
      createMvcIndex @
      @


# PRIVATE --------------------------------------------------------------------------


createMvcIndex = (module) -> 
  # Setup initial conditions.
  req = module.require
  get = Module.requirePart
  
  # Assign as properties (don't overwrite an existing property).
  setIndex = (propName, fnRequire) => 
          return if module[propName]?
          getIndex = (fnRequire) ->  
                          index = get(fnRequire, '')
                          index ?= {} # Empty object representing [index] if there was no module.
          module[propName] = getIndex fnRequire
  
  setIndex 'models',      module.model
  setIndex 'views',       module.view
  setIndex 'controllers', module.controller
  setIndex 'collections', module.collection
  setIndex 'utils',       module.util
  
  # Assign default views (if they exist).
  setView = (prop, name) => 
                return if module.views[prop]? # View has already been setup.
                view = get req.view, name
                module.views[prop] = view if view? # Only assign the property if the view was found.
  setView 'Root', 'root'
  setView 'Tmpl', 'tmpl'


partCache = {}
tryRequire = (module, dir, name = '', options = {}) -> 
  # Setup initial conditions.
  options.throw ?= true
  options.init  ?= true
  path = "#{module.modulePath}/#{dir}/#{name}"
  
  # Check if the part has already been retreived.
  cached = partCache[path]
  if cached?
    
    # TEMP 
    if path is 'open.client/harness/views/pane'
      console.log '+++ cached', path
      console.log 'options.init', options.init
      console.log 'part', cached.toString().substring 0, 100
      console.log ''
      
    # return cached
  
  # Retrieve the module part.
  part = module.tryRequire path, options
  
  
  # Invoke the [module-init] pattern if required.
  if part? and options.init
      part = Module.initPart module, part
  
  # if path is 'open.client/harness/views/pane'
  #   part = module.tryRequire path, options
  #   part = part(module)
    # console.log '**** path', path
    # console.log 'part', part.toString().substring 0, 100
    
    
    
    # p = new part() if _.isFunction(part)
    # console.log 'p', p
  
  # Finish up.
  partCache[path] = part
  part


# STATIC METHODS --------------------------------------------------------------------------


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
  part = fnRequire name, throw:false
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
  if _.isFunction(childModule)
    try
      return childModule(parentModule)
      
    catch error
      # Ignore - was an exported class only
      # It did not implement the module-init pattern.
  
  return childModule


###
Copy the self-propagating extend function that Backbone classes use.
NOTE: 
    This is so the Module can be extended using the classic approach
    shown in the Backbone documentation, which become important if
    the consuming application is being written in raw JavaScript and
    does not have the 'class' sugar of of CoffeeScript.
###
Module.extend = View.extend


