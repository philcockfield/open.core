describe 'controls/views/icon_button', ->
  IconButton = null
  btn        = null
  
  beforeEach ->
    IconButton = controls.IconButton
    btn = new IconButton()
  
  it 'exists', ->
    expect(IconButton).toBeDefined()
  
  it 'is a [Button]', ->
    expect(btn instanceof controls.Button).toEqual true 
  
  describe 'offsets', ->
    describe 'formatPoint', ->
      it 'changes nothing', ->
        expect(IconButton.formatPoint({x:5, y:3})).toEqual {x:5, y:3}
      
      it 'returns default 0:0', ->
        expect(IconButton.formatPoint()).toEqual {x:0, y:0}
      
      it 'assigns the Y value', ->
        expect(IconButton.formatPoint({x:5})).toEqual {x:5, y:0}
        
      it 'assigns the X value', ->
        expect(IconButton.formatPoint({y:5})).toEqual {x:0, y:5}
    
    describe 'iconOffset', ->
      it 'formats X', ->
        btn = new IconButton iconOffset:{y:5}
        expect(btn.iconOffset()).toEqual {x:0, y:5}
      
      it 'formats Y', ->
        btn = new IconButton iconOffset:{x:5}
        expect(btn.iconOffset()).toEqual {x:5, y:0}
      
    describe 'labelOffset', ->
      it 'formats X', ->
        btn = new IconButton labelOffset:{y:5}
        expect(btn.labelOffset()).toEqual {x:0, y:5}
      
      it 'formats Y', ->
        btn = new IconButton labelOffset:{x:5}
        expect(btn.labelOffset()).toEqual {x:5, y:0}
      
