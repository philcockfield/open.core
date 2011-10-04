module.exports = index =
  javascript: require './javascript'
  send:       require './send'
  fs:         require './fs'
  cake:       require './cake'
  git:        require './git'
  html:       require './html'
  Timer:      require './timer'

# Copy the common utility methods onto the index.
_.extend index, require('./common')
