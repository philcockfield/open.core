describe 'controls/controllers/scroll', ->
  View   = null
  Scroll = null
  
  class MyView extends core.mvc.View
    defaults:
      scroll: 'y'
  
  class MyScrollView extends MyView
    constructor: (props = {}) -> 
      super 
      new Scroll @
        
  
  
  beforeEach ->
    View    = core.mvc.View
    Scroll  = controls.controllers.Scroll
  
  it 'exists', ->
    expect(Scroll).toBeDefined()
  
  it 'adds a [scroll] property function to a view', ->
    view = new View()
    expect(view.scroll).not.toBeDefined()
    new Scroll(view)
    expect(view.scroll.onChanged instanceof Function).toEqual true 
  
  it 'keeps a pre-defined [scroll] property', ->
    view = new MyView()
    new Scroll view
    expect(view.scroll()).toEqual 'y'
  
  
  it 'converts property to lower case', ->
    view = new MyScrollView()
    view.scroll 'XY'
    expect(view.scroll()).toEqual 'xy'
  
  it 'throws if a non valid valid is passed', ->
    view = new MyScrollView()
    view.scroll 'z'
  
  
  describe 'delegate to syncScroll() method', ->
    callArgs = -> core.util.syncScroll.mostRecentCall.args
    beforeEach ->
    
    it 'syncs scroll on construction', ->
      spyOn(core.util, 'syncScroll')
      view = new MyScrollView()
      args = callArgs()
      
      expect(core.util.syncScroll.callCount).toEqual 1
      expect(args[0]).toEqual view.el
      expect(args[1]).toEqual 'y'
    
    it 'syncs on property changed', ->
      view = new MyScrollView()
      
      spyOn(core.util, 'syncScroll')
      view.scroll 'x'
      args = callArgs()
      
      expect(core.util.syncScroll.callCount).toEqual 1
      expect(args[0]).toEqual view.el
      expect(args[1]).toEqual 'x'
      
    
    
    
  
  
  
  
  