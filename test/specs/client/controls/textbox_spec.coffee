controls = require 'open.client/controls/index'

describe 'client/controls/textbox', ->
  textbox = null
  beforeEach ->
      textbox = new controls.Textbox()  
  
  describe 'single-line', ->
    it 'is single-line by default', ->
      expect(textbox.multiline()).toEqual false
      
    
  
    
  
  
  