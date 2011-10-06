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
        
      
    
  
    
  
  
  
  