describe 'controls/tab_strip', ->
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
    expect(new Tab(tabStrip) instanceof controls.Button).toEqual true 
  
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
      expect(tab instanceof controls.Button).toEqual true 
    
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
    
    
  
  
  