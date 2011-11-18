module.exports = index =
  javascript: require './javascript'
  send:       require './send'
  fs:         require './fs'
  tasks:      require './tasks'
  git:        require './git'
  html:       require './html'
  testing:    require './testing'
  
  # Classes.
  Timer:      require './timer'
  Pygments:   require './converters/pygments'
  Markdown:   require './converters/markdown'


# Copy the common utility methods onto the index.
_.extend index, require('./common')
