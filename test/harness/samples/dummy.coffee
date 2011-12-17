core = require 'open.client/core'

module.exports = class DummyView extends core.mvc.View
  constructor: (props = {}) -> 
    super _.extend props, className: 'test_dummy'
