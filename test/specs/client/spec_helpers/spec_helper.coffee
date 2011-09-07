window.core     = require 'open.client/core'
window.controls = require 'open.client/controls/index'

window.ensure =
  ###
  Ensures the parent constructor of the given class was called.
  @param Class to spy on.
  @param fnAction to invoke that should cause the 'super' to be called.
  ###
  parentConstructorWasCalled: (Class, fnAction) ->
      spyOn(Class.__super__, 'constructor').andCallThrough()
      fnAction?()
      expect(Class.__super__.constructor).toHaveBeenCalled()


