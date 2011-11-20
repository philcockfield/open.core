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
  
  # Classes.
  Timer:      require './timer'


# Copy the common utility methods onto the index.
_.extend index, require('./common')
