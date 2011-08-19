using = (module) -> require 'open.client/core/' + module
Base     = using 'base'
common   = using '/mvc/_common'
util     = using 'util'

module.exports = class Module extends Base
  tryRequire: util.tryRequire
  
  ###
  Constructor.
  @param modulePath: The path to the module.
  ###
  constructor: (modulePath) -> 
      super
      _require = (dir) => 
          return (name = '', options = {}) => 
              options.throw ?= true
              @tryRequire "#{modulePath}/#{dir}/#{name}", options
      
      ###
      An index of helper methods for requiring modules within the MVC folder structure of the module.
      For example, to retrieve a module named 'foo' within the /models folder:
        foo = module.require.model('foo')
      ###    
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
  Initializes the module (overridable).
  @param options
          - within: The CSS selector, DOM element, JQuery Object or [View] to initialize 
                    the module wihtin.  Passing 'options' param through the base 'init' method
                    converts whatever type of value to a jQuery element.
  ###
  init: (options = {}) -> 
      
      # Construct MVC index.
      get = (fn) -> fn '', throw:false
      @index =
          models: get @require.model
          views: get @require.view
          controllers: get @require.controller
  
      # Translate [within] option to jQuery object.
      within = options.within
      if within?
          if (within instanceof jQuery) # Ignore - no translation needed (already a jQuery object).

          else if (within.el instanceof jQuery) 
            # Retrieve jQuery .el from supplied [View]
            options.within = within.el

          else if _.isString(within) or (within instanceof HTMLElement)
            # Look up jQuery object from supplied CSS selector, or wrap supplied DOM element.
            options.within = $(within) 

              
            
            
        
        
          




