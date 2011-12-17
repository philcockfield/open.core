describe 'controls/views/tab_strip', ->
  TabStrip = null
  Tab      = null
  tabStrip = null
  
  beforeEach ->
      TabStrip = controls.TabStrip
      Tab      = TabStrip.Tab
      tabStrip = new TabStrip()
  
  it 'exists', ->
    expect(TabStrip).toBeDefined()
  
  it 'has static [Tab] property that is a [Button]', ->
    tab = new Tab(tabStrip)
    expect(tab instanceof controls.Button).toEqual true 
  
  it 'has a [tabs] property that is a [ButtonSet]', ->
    expect(tabStrip.tabs instanceof controls.ButtonSet).toEqual true 
  
  describe 'count() method', ->
    it 'has no tabs', ->
      expect(tabStrip.count()).toEqual 0
    
    it 'has two tabs', ->
      tabStrip.add()
      tabStrip.add()
      expect(tabStrip.count()).toEqual 2
  
  
  describe 'first/last', ->
    tab1 = null
    tab2 = null
    tab3 = null
    
    beforeEach ->
        tab1 = tabStrip.add()
        tab2 = tabStrip.add()
        tab3 = tabStrip.add()
    
    it 'retrieves the first tab', -> expect(tabStrip.first()).toEqual tab1
    it 'retrieves the last tab', -> expect(tabStrip.last()).toEqual tab3
    
    describe 'when there are no tabs', ->
      beforeEach -> tabStrip.clear()
      it 'retrieves null for the first tab', -> expect(tabStrip.first()).toEqual null
      it 'retrieves null for the last tab', -> expect(tabStrip.last()).toEqual null
  
  
  describe 'add() method', ->
    it 'returns a new tab intance', ->
      tab = tabStrip.add()
      expect(tab instanceof TabStrip.Tab).toEqual true 
    
    it 'assigns the given options to the tab', ->
      tab = tabStrip.add label:'foo'
      expect(tab.label()).toEqual 'foo'
    
    it 'creates a togglable tab buttons', ->
      expect(tabStrip.add().canToggle()).toEqual true
    
    it 'adds the tab to the [tabs] collection', ->
      tab = tabStrip.add()
      expect(tabStrip.tabs.contains(tab)).toEqual true
    
    it 'adds the tab element to the DOM.', ->
      tab = tabStrip.add()
      el = tabStrip.el.children()[0]
      expect(tab.el.get(0)).toEqual el
  
  
  describe 'remove() method', ->
    tab1 = null
    tab2 = null
    tab3 = null
    beforeEach ->
        tab1 = tabStrip.add()
        tab2 = tabStrip.add()
        tab3 = tabStrip.add()
    
    it 'removes the tab from the [tabs] collection', ->
      tabStrip.remove tab2
      expect(tabStrip.tabs.contains(tab2)).toEqual false

    it 'removes a tab using an index', ->
      tabStrip.remove 1
      expect(tabStrip.tabs.contains(tab2)).toEqual false

    it 'does not fail if no tab is specified', ->
      tabStrip.remove()
      tabStrip.remove(50)
    
    it 'removes the tab from the DOM', ->
      tabStrip.remove(tab1)
      tabStrip.remove(tab2)
      tabStrip.remove(tab3)
      expect(tabStrip.el.children().length).toEqual 0
    
    it 'does not fail if the tab does not exist within the strip', ->
      tab = new Tab(tabStrip)
      tabStrip.remove tab
    
    it 'fires [remove] event', ->
      args = null
      count = 0
      tab1.bind 'removed', (e) -> 
            count += 1
            args = e
            
      tabStrip.remove tab1
      expect(count).toEqual 1
      expect(args.tab).toEqual tab1
      expect(args.tabStrip).toEqual tabStrip
    

  describe 'clear() method', ->
    beforeEach ->
        tabStrip.add()
        tabStrip.add()
        tabStrip.add()
    
    it 'removes all items from the collection', ->
      tabStrip.clear()
      expect(tabStrip.count()).toEqual 0
      
    it 'removes all items from the DOM', ->
      tabStrip.clear()
      expect(tabStrip.el.children().length).toEqual 0

    it 'fires [remove] event when cleared', ->
      count = 0
      tabStrip.tabs.each (tab) -> 
          tab.bind 'removed', (e) -> count += 1
      tabStrip.clear()
      expect(count).toEqual 3
  
  
  describe 'position based CSS classes', ->
    tab1 = null
    tab2 = null
    tab3 = null
    beforeEach ->
        tab1 = tabStrip.add()
        tab2 = tabStrip.add()
        tab3 = tabStrip.add()
    describe '[core_first]', ->
      it 'adds [core_first] class to the first tab', ->
        expect(tab1.el.hasClass('core_first')).toEqual true
        expect(tab2.el.hasClass('core_first')).toEqual false
    
      it 'changes which tab has the [core_first] class when tab is removed', ->
        tabStrip.remove tab1
        expect(tab1.el.hasClass('core_first')).toEqual false
        expect(tab2.el.hasClass('core_first')).toEqual true
    
    describe '[core_before_selected]', ->
      it 'adds [core_before_selected] to first tab', ->
        tab2.selected true
        expect(tab1.el.hasClass('core_before_selected')).toEqual true
        
      it 'adds [core_before_selected] to second tab', ->
        tab3.selected true
        expect(tab2.el.hasClass('core_before_selected')).toEqual true
      
      it 'does nothing when the first tab is selected', ->
        tab3.selected true
        tab2.selected true
        tab1.selected true
        expect(tab1.el.hasClass('core_before_selected')).toEqual false
        expect(tab2.el.hasClass('core_before_selected')).toEqual false
        expect(tab3.el.hasClass('core_before_selected')).toEqual false
        
  
  describe '[selectionChanged] event', ->
    tab1 = null
    tab2 = null
    beforeEach ->
        tab1 = tabStrip.add()
        tab2 = tabStrip.add()
    
    it 'fires Selection changed event', ->
      args  = null
      count = 0
      tabStrip.bind 'selectionChanged', (e) -> 
            count += 1
            args = e
      tab2.click()
      expect(count).toEqual 1
      expect(args.tab).toEqual tab2

  describe '[count] event', ->
    count = 0
    args  = null
    
    
    beforeEach ->
      count = 0
      args  = null
      tabStrip.bind 'count', (e) -> 
          count += 1
          args = e
    
    it 'fires when a tab is added', ->
      tabStrip.add()
      expect(count).toEqual 1
      expect(args.count).toEqual 1
      
    it 'fires when a tab is removed', ->
      tabStrip.add()
      tabStrip.remove(0)
      expect(count).toEqual 2
      expect(args.count).toEqual 0
    
    
  describe 'init() method', ->
    tabs = [
      { label:'One', value:1 }
      { label:'Two', value:2 }
      { label:'Three', value:3, enabled:false }
    ]
    
    it 'adds the specified tabs to the strip.', ->
      tabStrip.init tabs
      buttons = tabStrip.tabs.items.models
      expect(buttons[0].value()).toEqual 1
      expect(buttons[1].label()).toEqual 'Two'
      expect(buttons[2].enabled()).toEqual false
      
    it 'adds a single tab (not specified as an array)', ->
      tabStrip.init label:'foo'
      expect(tabStrip.first().label()).toEqual 'foo'
      
    it 'returns the TabStrip (allows for calling during construction)', ->
      expect(tabStrip.init()).toEqual tabStrip
    
    it 'clears the existing tabs', ->
      spyOn(tabStrip, 'clear')
      tabStrip.init tabs
      expect(tabStrip.clear).toHaveBeenCalled()

  describe 'tab content element [elContent]', ->
    tab = null
    beforeEach -> tab = tabStrip.add()
    
    it 'has an [elContent] element', ->
      expect(tab.elContent).toBeDefined()
    
    it 'has an [elContent] element when constructor from the [init] method', ->
      tabStrip.init [label:'foo']
      expect(tabStrip.first().elContent).toBeDefined()
    
    it 'is hidden by default', ->
      expect(tab.elContent.css('display')).toEqual 'none'
    
    it 'is not hidden if the tab is selected at construction', ->
      tab = tabStrip.add selected:true
      expect(tab.elContent.css('display')).not.toEqual 'none'
    
    it 'has the [elContent] element when fired out of the tabs collection', ->
      args = null
      tabStrip.tabs.bind 'add', (e) -> args = e
      tab = tabStrip.add()
      expect(args.button.elContent).toBeDefined()
      expect(args.button.elContent).toEqual tab.elContent
    
    describe 'initializing with content', ->
      it 'adds the given HTML string to [elContent]', ->
        tab = tabStrip.add content:'foo'
        expect(tab.elContent.html()).toEqual 'foo'
      
      it 'adds the given jQuery object to [elContent]', ->
        div = $ '<div>Foo</div>'
        tab = tabStrip.add content:div
        expect(tab.elContent.children()[0]).toEqual div.get(0)

      it 'adds the given View object to [elContent]', ->
        view = new core.mvc.View()
        tab = tabStrip.add content:view
        expect(tab.elContent.children()[0]).toEqual view.element

      it 'does nothing if content is null', ->
        tab = tabStrip.add content:null
        expect(tab.elContent.html()).toEqual ''
      
      it 'adds initializes with content', ->
         tabStrip.init [
           { content:'foo' }
           { content:'bar' }
         ]
         tab1 = tabStrip.tab(0)
         tab2 = tabStrip.tab(1)
         expect(tab1.elContent.html()).toEqual 'foo'
         expect(tab2.elContent.html()).toEqual 'bar'
    
    
    describe 'content visibility based on tab selection', ->
      tab1 = null
      tab2 = null
      beforeEach ->
          tab1 = tabStrip.add()
          tab2 = tabStrip.add()
      
      it 'reveals the element when the tab is selected', ->
        tab1.selected true
        expect(tab1.elContent.css('display')).not.toEqual 'none'
        expect(tab2.elContent.css('display')).toEqual 'none'
      
      it 'hides the element when the tab is unselected', ->
        tab1.click()
        tab2.click()
        expect(tab1.elContent.css('display')).toEqual 'none'
        expect(tab2.elContent.css('display')).not.toEqual 'none'
      
      it 'does not fail if the [elContent] element is removed and selection changes', ->
        tab1.elContent = null
        delete tab2.elContent
        tab1.click()
        tab2.click()
      
      it 'changes the display property on a different element that is swapped into the [elContent] property', ->
        el = $ '<span>Foo</span>'
        tab1.elContent = el
        tab1.selected true
        tab1.selected false
        expect(el.css('display')).toEqual 'none'
      
  describe 'tab(index) method', ->
    tab1 = null
    tab2 = null
    beforeEach ->
        tab1 = tabStrip.add()
        tab2 = tabStrip.add()
    it 'gets the first tab',  -> expect(tabStrip.tab(0)).toEqual tab1
    it 'gets the second tab', -> expect(tabStrip.tab(1)).toEqual tab2
    it 'returns null when index is less than zero', -> expect(tabStrip.tab(-1)).toEqual null
    it 'returns null when index is greater than length', -> expect(tabStrip.tab(9)).toEqual null
    it 'returns null when index is not specified', -> expect(tabStrip.tab()).toEqual null
      
    
    
    
    
    
    
    
    





