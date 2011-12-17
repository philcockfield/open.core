describe 'controls/controllers/popup', ->
  PopupController = null
  controller      = null
  context = null
  popup   = null
  
  beforeEach ->
    PopupController = controls.controllers.Popup
    context         = new core.mvc.View()
    popup           = new core.mvc.View()
    controller      = new PopupController context, popup
  
  it 'exists', ->
    expect(PopupController).toBeDefined()
  
  describe 'element extraction', ->
    describe 'from views', ->
      beforeEach ->
        controller = new PopupController context, popup
      
      it 'exposes the context element', ->
        expect(controller.elContext).toEqual context.el
        
      it 'exposes the popup element', ->
        expect(controller.elPopup).toEqual popup.el
    
    describe 'from jQuery elements', ->
      beforeEach ->
        controller = new PopupController context.el, popup.el
        
      it 'exposes the context element', ->
        expect(controller.elContext).toEqual context.el
        
      it 'exposes the popup element', ->
        expect(controller.elPopup).toEqual popup.el
      
    
      
      
      
    
    
      
      
      