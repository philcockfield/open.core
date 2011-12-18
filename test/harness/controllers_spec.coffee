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
    posContext = (top, right, bottom, left) -> core.util.jQuery.absPos context, top, right, bottom, left
    
    it 'Init with View', -> initWithView()
    it 'Init with Button', -> initWithButton()
    it 'Edge: n', -> controller.edge = 'n'
    it 'Edge: s', -> controller.edge = 's'
    it 'Edge: w', -> controller.edge = 'w'
    it 'Edge: e', -> controller.edge = 'e'
    it 'Offset - 10:10',  -> controller.offset = { x:10, y:10 }
    it 'Offset - 0:0',    -> controller.offset = { x:0, y:0 }
    it 'Context: top-left',     -> posContext 0, null, null, 0
    it 'Context: bottom-left',  -> posContext null, null, 0, 0
    it 'Context: top-right',    -> posContext 0, 0, null, null
    it 'Context: bottom-right', -> posContext null, 0, 0, null
      
    
    
    
    
    
