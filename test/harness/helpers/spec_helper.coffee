window.core     = require 'open.client/core'
window.controls = require 'open.client/controls'

window.lorem = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vel eleifend nisl. Suspendisse tristique dignissim leo ut auctor.'
window.loremLong = do -> 
  long = lorem + ' '
  long += long for i in [1..10]
  long


window.loremWide = do -> 
  wide = lorem
  wide = wide.replace /\s/g, ''
  wide += wide for i in [1.3]
  wide


window.test = require 'core/test'
  
  
  
