tryRequire = (name) -> 
    try
      require name
    catch error
      # Ignore.  Code not referenced within page.


module.exports = 
  core:     tryRequire './core'
  controls: tryRequire './controls'
  harness:  tryRequire './harness'

