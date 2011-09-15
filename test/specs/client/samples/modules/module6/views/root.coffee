# NOTE: Implements the module-init pattern.

module.exports = (module) ->
  root =
    module: module
    note: 'This is from the file [root.coffee]'
  