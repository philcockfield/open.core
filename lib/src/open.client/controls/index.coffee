core   = require 'open.client/core'
Module = core.mvc.Module

class Controls extends Module
  constructor: -> super module


controls         = new Controls().init()
core.controls    = controls.views
Module::controls = core.controls

# Export.
module.exports   = core.controls

