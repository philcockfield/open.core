core     = require 'open.client/core'


###
Utility Tabs for the TestHarness.
###
module.exports = class TestHarnessTabs extends core.mvc.Module
  ###
  Constructor.
  @param parent: The parent [TestHarness] module.
  ###
  constructor: (@parent) -> 
    throw new Error('Parent [TestHarness] required.') unless @parent?
    super module


