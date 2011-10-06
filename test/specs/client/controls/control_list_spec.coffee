describe 'controls/control_list', ->
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
  
  it 'has a CSS class', ->
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

    
  
  
  
  