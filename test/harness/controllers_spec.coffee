describe 'Controllers', ->
  describe 'Popup Controller', ->
    context     = null
    popup       = null
    controller  = null
    
    beforeAll -> initWithView()
    
    init = (fnContext) -> 
      popup   = new test.Dummy width: 100, height:180
      context = fnContext()
      page.add context, reset:true
      controller = new controls.controllers.Popup context, popup
    
    initWithView = -> init -> new test.Dummy width: 50, height:50
    initWithButton = -> init -> new controls.CmdButton(label:'Context')
    
    it 'Init with View', -> initWithView()
    it 'Init with Button', -> initWithButton()
      
      
      
    
    
    
