core       = require 'open.server'
clientUtil = core.client.core.util


module.exports = index =
  javascript: require './javascript'
  send:       require './send'
  fs:         require './fs'
  tasks:      require './tasks'
  git:        require './git'
  html:       require './html'
  testing:    require './testing'
  markdown:   require './converters/markdown'
  pygments:   require './converters/pygments'
  http:       require './http'
  
  # Classes.
  Timer:      require './timer'
  
  # Aliased from client.
  escapeHtml:   clientUtil.escapeHtml
  unescapeHtml: clientUtil.unescapeHtml
  formatLinks:  clientUtil.formatLinks


# Copy the common utility methods onto the index.
_.extend index, require('./common')
