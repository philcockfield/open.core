using = (module) -> require 'open.client/core/' + module
util = using 'util'

module.exports = core =
  title:      'Open.Core (Client)'
  Base:       using 'base'
  mvc:        using 'mvc/index'
  util:       util
  tryRequire: util.tryRequire

  
 