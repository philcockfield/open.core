module.exports = (module) ->
  index =
    CodeSampleTab:  module.view 'code_sample_tab'
    ContextPane:    module.view 'context_pane'
    Main:           module.view 'main'
    Sidebar:        module.view 'sidebar'
    SpecButton:     module.view 'spec_button'
    SpecList:       module.view 'spec_list'
    SuiteButton:    module.view 'suite_button'
    SuiteList:      module.view 'suite_list'
    