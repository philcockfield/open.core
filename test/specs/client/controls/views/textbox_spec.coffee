Textbox = controls.Textbox

describe 'client/controls/views/textbox', ->
  textbox = null
  beforeEach ->
      textbox = new Textbox()  
  
  describe 'text', ->
    it 'has no text by default', ->
      expect(textbox.text()).toEqual ''
    
    describe 'updating INPUT when .text() property changes', ->
      it 'updates the INPUT (for single-line textbox)', ->
        textbox.text 'foo'
        expect(textbox._.input.val()).toEqual 'foo'
    
      it 'updates the INPUT (for password textbox)', ->
        textbox.password true
        textbox.text 'pwd'
        expect(textbox._.input.val()).toEqual 'pwd'
    
      it 'updates the INPUT (for multi-line textbox)', ->
        textbox.multiline true
        textbox.text 'bar'
        expect(textbox._.input.val()).toEqual 'bar'

    describe 'updating when .text() property when INPUT changes [on keyup event]', ->
      it 'updates the [text] property (for single-line textbox)', ->
        textbox._.input.val 'foo'
        textbox._.input.keyup()
        expect(textbox.text()).toEqual 'foo'

      it 'updates the [text] property (for password textbox)', ->
        textbox.password true
        textbox._.input.val 'pwd'
        textbox._.input.keyup()
        expect(textbox.text()).toEqual 'pwd'

      it 'updates the [text] property (for multi-line textbox)', ->
        textbox.multiline true
        textbox._.input.val 'foo'
        textbox._.input.keyup()
        expect(textbox.text()).toEqual 'foo'

    describe 'updating when .text() property when INPUT changes [on change event]', ->
      it 'updates the [text] property (for single-line textbox)', ->
        textbox._.input.val 'foo'
        textbox._.input.change()
        expect(textbox.text()).toEqual 'foo'

      it 'updates the [text] property (for password textbox)', ->
        textbox.password true
        textbox._.input.val 'pwd'
        textbox._.input.change()
        expect(textbox.text()).toEqual 'pwd'

      it 'updates the [text] property (for multi-line textbox)', ->
        textbox.multiline true
        textbox._.input.val 'foo'
        textbox._.input.change()
        expect(textbox.text()).toEqual 'foo'
    
  
  describe 'single-line', ->
    it 'is single-line by default', ->
      expect(textbox.multiline()).toEqual false
    
    it 'contains an text INPUT when single line', ->
      input = textbox.$('INPUT[type = text]')
      expect(input.length).toEqual 1
    

  describe 'multi-line', ->
    beforeEach -> textbox = new Textbox(multiline:true)
    
    it 'constructs as multi-line', ->
      expect(textbox.multiline()).toEqual true

    it 'contains an TEXTAREA when single line', ->
      input = textbox.$('TEXTAREA')
      expect(input.length).toEqual 1
    
    it 're-renders when [multiline] changes', ->
      spyOn textbox, 'render'
      textbox.multiline false
      expect(textbox.render).toHaveBeenCalled()
      
    
  describe 'password', ->
    beforeEach -> textbox = new Textbox( password:true )
    
    it 'is not a password by default', ->
      expect(new Textbox().password()).toEqual false

    it 'constructs as password', ->
      expect(textbox.password()).toEqual true
      
    it 'contains an password INPUT when single line', ->
      input = textbox.$('INPUT[type = password]')
      expect(input.length).toEqual 1

    it 'does not contain a password INPUT when multi-line', ->
      textbox.multiline true
      input = textbox.$('INPUT[type = password]')
      expect(input.length).toEqual 0

    it 're-renders when [password] changes', ->
      spyOn textbox, 'render'
      textbox.password false
      expect(textbox.render).toHaveBeenCalled()
    
        
  describe 'focus', ->
    it 'has a focus method', ->
      expect(textbox.focus instanceof Function).toEqual true 
    
    it 'invokes focus on the underlying input', ->
      spyOn textbox._.input, 'focus'
      textbox.focus()
      expect(textbox._.input.focus).toHaveBeenCalled()
    
    it 'does not have focus', ->
      expect(textbox.hasFocus()).toEqual false
      

  describe '_input (element reference)', ->
    it 'has _input when standard single-line', ->
      expect(textbox._.input.get(0).tagName).toEqual 'INPUT'
      
    it 'has _input when password', ->
      textbox = new Textbox(password:true)
      expect(textbox._.input.get(0).tagName).toEqual 'INPUT'

    it 'has _input when standard multiline-line', ->
      textbox = new Textbox(multiline:true)
      expect(textbox._.input.get(0).tagName).toEqual 'TEXTAREA'
      
  describe 'empty() method', ->
    describe 'is not empty', ->
      it 'has text', ->
        textbox.text '  foo '
        expect(textbox.empty()).toEqual false
      
      it 'has white space only (not trimmed)', ->
        textbox.text '   '
        expect(textbox.empty(false)).toEqual false
    
    describe 'is empty', ->
      it 'empty string', ->
        textbox.text ''
        expect(textbox.empty()).toEqual true

      it 'white space', ->
        textbox.text '    '
        expect(textbox.empty()).toEqual true

      it 'null', ->
        textbox.text null
        expect(textbox.empty()).toEqual true

      it 'undefined', ->
        textbox.text undefined
        expect(textbox.empty()).toEqual true

  describe 'prompt (watermark)', ->
    it 'does not have a [prompt] by default', ->
      expect(textbox.prompt()).toEqual ''
    
          
    
        
  
    
  
  
  