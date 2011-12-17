describe 'controls/views/control_list', ->
  ControlList = null
  list        = null
  beforeEach ->
      ControlList = controls.ControlList
      list = new ControlList()
  
  it 'exists', ->
    expect(ControlList).toBeDefined()
  
  it 'is an MVC View', ->
    expect(list instanceof core.mvc.View).toEqual true 
  
  it 'is an unordered list (UL)', ->
    expect(list.el.get(0).tagName.toLowerCase()).toEqual 'ul'
  
  it 'has the default CSS class', ->
    expect(list.el.hasClass('core_control_list')).toEqual true
  
  it 'has a controls collection', ->
    expect(list.controls instanceof core.mvc.Collection).toEqual true 
  
  describe 'add() method', ->
    control = null
    beforeEach ->
        control = new core.mvc.View()
    
    it 'returns the added control', ->
      expect(list.add(control)).toEqual control
    
    it 'adds the new control to the [buttons] collection', ->
      list.add control
      expect(list.controls.contains(control)).toEqual true
    
    it 'inserts the into into the UL within an LI', ->
      list.add control
      li = list.$ 'li'
      expect(li.length).toEqual 1
      
      elControl = li.children().get(0)
      expect(elControl).toEqual control.el.get(0)
  
  describe 'count() method', ->
    it 'has zero count', ->
      expect(list.count()).toEqual 0
    
    it 'has a count of two items', ->
      list.add(new core.mvc.View())
      list.add(new core.mvc.View())
      expect(list.count()).toEqual 2
  
  describe 'first / last', ->
    describe 'with three controls', ->
      control1 = null
      control2 = null
      control3 = null
      beforeEach ->
        control1 = list.add(new core.mvc.View())
        control2 = list.add(new core.mvc.View())
        control3 = list.add(new core.mvc.View())
    
      it 'retrieves the first control', -> expect(list.first()).toEqual control1
      it 'retrieves the last control', -> expect(list.last()).toEqual control3
    
    describe 'with one control', ->
      control = null
      beforeEach -> control = list.add(new core.mvc.View())
      it 'retrieves the first control', -> expect(list.first()).toEqual control
      it 'retrieves the last control', -> expect(list.last()).toEqual control
    
    describe 'with no controls', ->
      it 'retrieves the first control', -> expect(list.first()).toEqual null
      it 'retrieves the last control', -> expect(list.last()).toEqual null
  
  
  describe 'orientation', ->
    it 'has vertical orientation by default (Y)', ->
      expect(list.orientation()).toEqual 'y'
    
    it 'converts X to x (lowercase)', ->
      list.orientation 'X'
      expect(list.orientation()).toEqual 'x'
      
    it 'converts Y to y (lowercase)', ->
      list.orientation 'Y'
      expect(list.orientation()).toEqual 'y'
    
    describe 'orientation CSS classes', ->
      it 'has a CSS class signifying horizontal orientation (X)', ->
        list.orientation 'x'
        expect(list.el.hasClass('core_x')).toEqual true
        expect(list.el.hasClass('core_y')).toEqual false
      
      it 'has a CSS class signifying vertical orientation (Y)', ->
        list.orientation 'y'
        expect(list.el.hasClass('core_x')).toEqual false
        expect(list.el.hasClass('core_y')).toEqual true
    
      it 'has the vertical CSS class by default (Y)', ->
        expect(list.el.hasClass('core_y')).toEqual true
      
      it 'constructs with the horizontal CSS class (X)', ->
        list = new ControlList orientation:'x'
        expect(list.el.hasClass('core_x')).toEqual true
  
  describe 'remove() method', ->
    item1 = null
    item2 = null
    beforeEach ->
      add = (text) -> 
        view = list.add(new core.mvc.View())
        view.html text
        view
      item1 = add 'one'
      item2 = add 'two'
    
    it 'does nothing when no item is provided', ->
      list.remove()
      expect(list.count()).toEqual 2
    
    it 'returns the list', ->
      expect(list.remove()).toEqual list
      expect(list.remove(item1)).toEqual list
    
    it 'removes the given item from the [controls] collection', ->
      list.remove item1
      expect(list.controls.include(item1)).toEqual false
    
    it 'removes the given item from the DOM', ->
      list.remove item1
      for el in list.$('li > div')
        expect(el).not.toEqual item1.el.get(0)
  
    it 'removes both items from the DOM', ->
      list.remove item1
      list.remove item2
      expect(list.el.children().length).toEqual 0
    
    it 'does nothing when remove is called with the same control multiple times.', ->
      list.remove item1
      list.remove item1
      expect(list.count()).toEqual 1
  
  describe 'clear() method', ->
    beforeEach ->
      add = (text) -> 
        view = list.add(new core.mvc.View())
        view.html text
        view
      item1 = add 'one'
      item2 = add 'two'
    
    it 'removes items from the DOM', ->
      list.clear()
      expect(list.el.children().length).toEqual 0
      
    it 'removes items from the [controls] collection', ->
      list.clear()
      expect(list.controls.length).toEqual 0
  
    it 'invokes the [remove] method', ->
      spyOn(list, 'remove')
      list.clear()
      expect(list.remove.callCount).toEqual 2
    
  describe 'init() method', ->
    controls = []
    beforeEach ->
      controls = [
        new core.mvc.View()
        new core.mvc.View()
      ]
    
    it 'returns the [list] instance', ->
      expect(list.init()).toEqual list
    
    it 'passes the controls to the [add] method', ->
      spyOn(list, 'add')
      list.init controls
      expect(list.add.calls[0].args[0]).toEqual controls[0]
      expect(list.add.calls[1].args[0]).toEqual controls[1]
    
    it 'clears before initializing', ->
      spyOn(list, 'clear')
      list.init controls
      expect(list.clear).toHaveBeenCalled()
  
    



