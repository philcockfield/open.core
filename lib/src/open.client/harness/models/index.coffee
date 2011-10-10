module.exports = (module) ->
  index =
    Describe: module.model 'describe'
    It:       module.model 'it'