Base = require '../base'

###
Base class for models.
###
module.exports = class Model extends Base
  constructor: (params = {}) ->
      # Setup initial conditions.
      super
