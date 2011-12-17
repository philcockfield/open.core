describe 'controls/views/combo_box', ->
  ComboBox = null
  cbo      = null
  beforeEach ->
      ComboBox = controls.ComboBox
      cbo      = new ComboBox()
  
  it 'exists', ->
    expect(controls.ComboBox).toBeDefined()
  
  it 'is an MVC View', ->
    expect(cbo instanceof core.mvc.View).toEqual true 
  
  it 'has a CSS class', ->
    expect(cbo.el.hasClass('core_combo_box')).toEqual true
  
  it 'has an Items collection', ->
    expect(cbo.items instanceof ComboBox.ItemsCollection).toEqual true 
  
  
  describe '[Item] model', ->
    it 'has a [label] property', ->
      item = new ComboBox.Item label:'foo'
      expect(item.label()).toEqual 'foo'

    it 'has a [value] property', ->
      item = new ComboBox.Item value:'bar'
      expect(item.value()).toEqual 'bar'

    it 'has a [selected] property', ->
      item = new ComboBox.Item()
      expect(item.selected()).toEqual false
  
  
  describe 'add() method', ->
    describe 'adding an item from an object-literal', ->
      it 'returns a new Item model', ->
        item = cbo.add()
        expect(item instanceof ComboBox.Item).toEqual true 
      
      it 'adds the new Item model to the collection', ->
        item = cbo.add()
        expect(cbo.items.include(item)).toEqual true
      
      it 'passes settings to the model constructor', ->
        item = cbo.add label:'foo', value:123, selected:true
        expect(item.label()).toEqual 'foo'
        expect(item.value()).toEqual 123
        expect(item.selected()).toEqual true
      
      it 'converts a string parameter to the label', ->
        item = cbo.add 'label'
        expect(item.label()).toEqual 'label'
      
      it 'inserts the corresponding <option> element', ->
        item = cbo.add value:123, label:'foo'
        el = cbo.$('option')
        expect(el.attr('value')).toEqual '123'
        expect(el.html()).toEqual 'foo'
      
      it 'selects the first item', ->
        item1 = cbo.add()
        item2 = cbo.add()
        expect(item1.selected()).toEqual true
        expect(item2.selected()).toEqual false
      
      it 'updates the selection state on the element upon adding', ->
        item1 = cbo.add()
        item2 = cbo.add selected:true
        el = cbo._optionEl(item2)
        
        html = View.outerHtml(el).toLowerCase()
        expect(_(html).includes 'selected="selected"').toEqual true
      
      it 'unselects the existing item selection upon adding an element that is selected', ->
        item1 = cbo.add()
        item2 = cbo.add selected:true
        expect(item1.selected()).toEqual false
        expect(item2.selected()).toEqual true
    
    describe 'adding a custom model', ->
      model = null
      beforeEach -> model = new core.mvc.Model()
      
      it 'adds a custom model', ->
        expect(cbo.add(model)).toEqual model
        expect(cbo.items.include(model)).toEqual true
      
      it 'does not fail if the model does not support all properties', ->
        cbo.add model
        el = cbo.$('option')
        html = "<option data-cid=\"#{model.cid}\"></option>"
        expect(View.outerHtml(el).toLowerCase()).toEqual html
      
  describe '<option> element synchronization with [Item] model', ->
    item1 = null
    item2 = null
    el1   = null
    el2   = null
    beforeEach ->
      item1 = cbo.add label:'one', value:1
      item2 = cbo.add label:'two', value:2
      el1   = cbo._optionEl item1
      el2   = cbo._optionEl item2
    
    it 'updates the [value] on the element', ->
      item1.value 'foo'
      expect(el1.attr('value')).toEqual 'foo'
    
    it 'updates the [label] on the element', ->
      item2.label 'bar'
      expect(el2.html()).toEqual 'bar'
    
    it 'adds the [selected] attribute', ->
      item2.selected true
      el = cbo.$ 'option:selected'
      expect(el.val()).toEqual '2'
    
    it 'removes the [selected] attribute', ->
      item2.selected true
      item2.selected false
      el = cbo.$ 'option:selected'
      
      for option in cbo.$ 'option'
        # NB: This painful HTML conversion is required because
        # jQuery does not report accurately on the 'selected' attribute
        #  in Firefox.
        html = View.outerHtml option
        expect(_(html).includes('selected')).toEqual false
      
  describe '_optionEl() method', ->
    item1 = null
    item2 = null
    beforeEach ->
      item1 = cbo.add label:'one', value:1
      item2 = cbo.add label:'two', value:2
    
    it 'retrieves the first element', ->
      el = cbo._optionEl item1
      expect(el.attr('value')).toEqual '1'
      
    it 'retrieves the second element', ->
      el = cbo._optionEl item2
      expect(el.attr('value')).toEqual '2'
      
    it 'returns null when the model does not exist', ->
      expect(cbo._optionEl(new core.mvc.Model())).toEqual null
      
    it 'returns null when no model is passed ', ->
      expect(cbo._optionEl()).toEqual null
  
  describe 'selected', ->
    item1 = null
    item2 = null
    item3 = null
    beforeEach ->
      item1 = cbo.add value:1
      item2 = cbo.add value:2
      item3 = cbo.add value:3
    
    it 'has nothing selected by default', ->
      cbo = new ComboBox()
      expect(cbo.selected()).toEqual null
    
    it 'has the first item selected', ->
      expect(cbo.selected()).toEqual item1
    
    it 'has the second item selected (via the model changing)', ->
      item2.selected true
      expect(cbo.selected()).toEqual item2
    
    it 'has the second item selected (via the selected method changing)', ->
      cbo.selected item2
      expect(cbo.selected()).toEqual item2
      expect(item2.selected()).toEqual true
    
    it 'deselects the existing selection', ->
      item1.selected true
      item2.selected true
      expect(item1.selected()).toEqual false
      expect(item2.selected()).toEqual true
    
    it 'clears selection', ->
      cbo.selected null
      expect(cbo.selected()).toEqual null
      expect(item1.selected()).toEqual false
    
    describe 'selection with an index', ->
      it 'selects the first item', ->
        item3.selected true
        cbo.selected 0
        expect(cbo.selected()).toEqual item1
      
      it 'selects the last item', ->
        cbo.selected 2
        expect(cbo.selected()).toEqual item3  
      
      it 'selects nothing when the index is out of bounds (lower)', ->
        cbo.selected -1
        expect(cbo.selected()).toEqual null
      
      it 'selects nothing when the index is out of bounds (upper)', ->
        cbo.selected 50
        expect(cbo.selected()).toEqual null
  
  describe 'item() method', ->
    item1 = null
    item2 = null
    item3 = null
    beforeEach ->
      item1 = cbo.add value:1
      item2 = cbo.add value:2
      item3 = cbo.add value:3
    
    it 'retreives the first item', -> expect(cbo.item(0)).toEqual item1
    it 'retreives the last item', -> expect(cbo.item(2)).toEqual item3
    it 'retreives null when index is out of bounds (lower)', -> expect(cbo.item(-1)).toEqual null
    it 'retreives null when index is out of bounds (upper)', -> expect(cbo.item(20)).toEqual null
  
  describe 'init() method', ->
    def = [
      { label:'one' }
      { label:'two', value:2 }
      { label:'three', selected:true }
    ]
    
    it 'returns the ComboBox', ->
      expect(cbo.init(def)).toEqual cbo
    
    it 'does nothing if no array is passed', ->
      cbo.init()
      expect(cbo.items.length).toEqual 0
    
    it 'adds the items', ->
      cbo.init def
      expect(cbo.items.length).toEqual 3
      expect(cbo.item(0).label()).toEqual 'one'
      expect(cbo.item(1).value()).toEqual 2
      expect(cbo.selected()).toEqual cbo.item(2)
      
    it 'converts a single item into an array', ->
      cbo.init label:'foo'
      expect(cbo.items.first().label()).toEqual 'foo'
    
    it 'clears the ComboBox before initializing', ->
      spyOn(cbo, 'clear')
      cbo.init def
      expect(cbo.clear.callCount).toEqual 1

  describe 'remove() method', ->
    beforeEach ->
      cbo.init [
        { value:1 }
        { value:2 }
        { value:3 }
      ]
    
    it ' does nothing if no item is specified', ->
      cbo.remove()
      expect(cbo.items.length).toEqual 3
    
    it ' does nothing if the item does not exist in the collection', ->
      cbo.remove(new ComboBox.Item())
      expect(cbo.items.length).toEqual 3
    
    it 'removes the item from the [items] collection', ->
      item1 = cbo.item(0)
      cbo.remove item1
      expect(cbo.items.length).toEqual 2
      expect(cbo.items.find((o) -> o is item1)).toEqual null
    
    it 'removes <option> element', ->
      item1 = cbo.item(0)
      cbo.remove item1
      expect(cbo._optionEl(item1)).toEqual null
  
  describe 'clear() method', ->
    beforeEach ->
      cbo.init [
        { value:1 }
        { value:2 }
        { value:3 }
      ]
    
    it 'removes all items', ->
      cbo.clear()
      expect(cbo.items.length).toEqual 0
      expect(cbo.el.children().length).toEqual 0



