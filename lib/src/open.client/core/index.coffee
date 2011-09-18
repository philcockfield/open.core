util = require './util'

module.exports = core =
  title:      'Open.Core (Client)'
  Base:       require './base'
  mvc:        require './mvc'
  util:       util
  tryRequire: util.tryRequire
 