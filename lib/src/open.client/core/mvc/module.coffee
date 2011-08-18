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
  Initializes the module (overridable).
  ###
  init: -> 
      get = (fn) -> fn '', throw:false
      @index =
          models: get @require.model
          views: get @require.view
          controllers: get @require.controller
  
  




