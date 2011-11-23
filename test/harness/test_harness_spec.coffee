describe 'Test Harness', ->
  TestHarness = null
  pane        = null
  beforeAll ->
    TestHarness = require 'open.client/harness'
    pane = page.pane
    pane.reset()
  
  describe 'Pane', ->
    SampleView = null
    pane       = null
    beforeAll -> 
        
        SampleView = class SampleView extends core.mvc.View
            constructor: (options = {}) -> 
                super options
                @el.css 'margin', '20px'
                @html options.text ?= 'Untitled'
        
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
            page.css '/stylesheets/dev/test.css'
            
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
  
  
  describe 'Page', ->
    div = null
    beforeEach ->
      page.reset()
      div = $ '<div style="background:orange">Element</div>'
    
    it 'Add - width:100, height:250', -> page.add div, width:100, height:250
    it 'Add - width:*, height:*', -> page.add div, width:'*', height:'*'
    it 'Add - width:0.3, height:0.8', -> page.add div, width:0.3, height:0.8
    it 'Add - width:1, height:1', -> page.add div, width:1, height:1
    
    it 'Add - fill:true', -> page.add div, fill:true
    it 'Add - fill:80%', -> page.add div, fill:'80%'
    it 'Add - fill:0.8 (80%)', -> page.add div, fill:0.8
    it 'Add - fill:1 (100%)', -> page.add div, fill:1
    
  describe 'Tabs', ->
    harness = null
    tabs    = null
    tab     = null
    beforeAll -> 
      harness = new TestHarness().init( debug:true )
      tabs    = harness.tabs
    
    setScroll = (value) -> 
      tab.el.html "#{loremWide} #{loremLong}"
      tab.scroll value
    
    
    describe 'Tab (Base)', 'Base class for all common utility tabs provided by the TestHarness.', ->
      beforeAll ->
        tab = new tabs.views.Base()
        page.add tab, width:700, height: 250, border:true
      it 'addToPane()',   -> 
        page.reset()
        tab = new tabs.views.Base().addToPane label:'Base Tab'
      
      it 'Scroll: XY',    -> setScroll 'xy'
      it 'Scroll: Y',     -> setScroll 'y'
      it 'Scroll: null',  -> setScroll null
    
    describe 'Markdown Tab', 'Renders markdown', ->
      beforeAll ->
        tab = new tabs.views.Markdown markdown:sampleMarkdown
        page.add tab, width:0.8, height: 250, border:true
      
      it 'addToPane()', -> 
        page.reset()
        
        count    = page.pane.count() + 1
        markdown = sampleMarkdown
        markdown = markdown.replace 'H1 Title', "H1 Title #{count}"
        
        page.pane.add.markdown
          label:    "Markdown #{count}"
          markdown: markdown
      
      it 'Markdown: null',   -> tab.markdown null
      it 'Markdown: Sample', -> tab.markdown sampleMarkdown
      
      sampleMarkdown =
         """
         # H1 Title
         #{lorem}
         [Internal linke](/harness/#test%20harness/tabs/markdown%20tab)
         and [external link](http://www.google.com).
         
         - Item 1
         - Item 2
         - Item 3
         
         Some `code`:
         
             :coffee
             # Comment. <foo> & 'thing' in "quotes".
             foo = 123
             fn = (prefix) -> console.log "Thing: ", foo
             for i in [1..5]
               foo += 1
               fn('Item')
         
         ## H2 Title
         ### H3 Title
         #### H4 Title
         ##### H5 Title
         
         
         """




