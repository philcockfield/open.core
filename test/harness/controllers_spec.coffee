describe 'Controllers', ->
  describe 'Popup Controller', ->
    context     = null
    popup       = null
    controller  = null
    
    beforeAll ->
      popup   = new test.Dummy width: 100, height:180
      context = new test.Dummy width: 50, height:50
      page.add context
      
      controller = new controls.controllers.Popup context, popup
    
    
    
    
    
