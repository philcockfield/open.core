core   = require 'open.client/core'
Module = core.mvc.Module

class Controls extends Module
  constructor: -> super module


controls         = new Controls().init()
views            = controls.views
Module::controls = views


# Export.
module.exports   = views
