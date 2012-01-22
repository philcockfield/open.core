module.exports = (module) ->
  index =
    Base:     module.view 'base'
    Markdown: module.view 'markdown'
    Remote:   module.view 'remote'


    