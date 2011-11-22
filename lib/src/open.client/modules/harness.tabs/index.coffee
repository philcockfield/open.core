core     = require 'open.client/core'

###
Utility Tabs for the TestHarness.
###
module.exports = class TestHarnessTabs extends core.mvc.Module
  constructor: -> 
    super module
    @util = core.util


