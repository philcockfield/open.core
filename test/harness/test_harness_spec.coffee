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
  
  
  describe 'Before | After Execution Sequence', ->
    describe 'A', ->
      beforeAll -> 
            console.log '++ Before All: A' # Create and insert view here.

            el = $('<div class="foo">Hello I am an element.</div>')
            
            options = 
                width: '80%'
                height: '60%'
                # css: '/stylesheets/dev/test.css'
                # showTitle: false

            page.css '/stylesheets/dev/test.css'
            
            page.add el, options
            
            
            
      afterAll  -> console.log '++ After All: A'
          
      beforeEach -> console.log '+ Before Each: A'
      afterEach  -> console.log '- After Each: A'
    
      describe 'B', ->

          beforeAll -> console.log '++ Before All: B' 
          afterAll  -> console.log '++ After All: B'

          beforeEach -> console.log '+ Before Each: B'
          afterEach  -> console.log '- After Each: B'
            
          describe 'C', ->
            beforeEach -> console.log '+ Before Each: C'
            afterEach  -> console.log '- After Each: C'
        
            it 'Does It', ->
              console.log 'Spec C'  
