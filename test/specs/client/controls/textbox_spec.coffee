controls = require 'open.client/controls/index'
Textbox = controls.Textbox

describe 'client/controls/textbox', ->
  textbox = null
  beforeEach ->
      textbox = new Textbox()  
  
  describe 'text', ->
    it 'has no text by default', ->
      expect(textbox.text()).toEqual ''
    
  
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
    
        
    
    
  
    
  
  
  