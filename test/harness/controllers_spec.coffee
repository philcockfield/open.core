describe 'Controllers', ->
  describe 'Popup Controller', ->
    context     = null
    controller  = null
    
    beforeAll -> initWithView()
    
    fnPopup = -> new test.Dummy width: 200, height:180, color:'green' 
    
    init = (fnContext) -> 
      context = fnContext()
      page.add context, reset:true
      controller = new controls.controllers.Popup context, fnPopup
    
    initWithView = -> init -> new test.Dummy width: 50, height:50
    initWithButton = -> init -> new controls.CmdButton(label:'Context')
    
    it 'Init with View', -> initWithView()
    it 'Init with Button', -> initWithButton()
      
      
      
    
    
    
