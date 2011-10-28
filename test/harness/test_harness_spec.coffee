describe 'Test Harness', ->
  
  describe 'Pane', ->
    SampleView = null
    pane       = null
    beforeAll -> 
        
        SampleView = class SampleView extends core.mvc.View
            constructor: (options = {}) -> 
                super options
                @el.css 'margin', '20px'
                @html options.text ?= 'Untitled'
        
        pane = page.pane
        pane.show()
        add() for i in [1,2,3]
        
    
    add = -> 
        number = pane.tabStrip.count() + 1
        view = new SampleView text:"Tab Content #{number}"
        pane.add label:"Tab #{number}", content:view
    
    it 'Show', -> pane.show()
    it 'Show with height:100', -> pane.show height:100
    it 'Hide', -> pane.hide()
    it 'Height: 20', -> pane.height 20
    it 'Height: 200', -> pane.height 200
    it 'Add Tab', -> add()
    it 'Remove First Tab', -> 
        tab = pane.tabStrip.first()
        tab?.remove()
    it 'Clear', -> pane.clear()
  
  
  
  