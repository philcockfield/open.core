module.exports = (module) ->
  index =
    ContextPane:    module.view 'pane'
    Main:           module.view 'main'
    Sidebar:        module.view 'sidebar'
    SpecButton:     module.view 'spec_button'
    SpecList:       module.view 'spec_list'
    SuiteButton:    module.view 'suite_button'
    SuiteList:      module.view 'suite_list'

    