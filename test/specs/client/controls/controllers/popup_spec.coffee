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
  
  describe 'show()', ->
    it 'invokes show when element is clicked', ->
      spyOn(controller, 'show')
      context.el.click()
      expect(controller.show).toHaveBeenCalled()
    
    it 'invokes show when a [Button] is clicked', ->
      contextBtn  = new controls.CmdButton()
      controller  = new PopupController contextBtn, popup
      spyOn(controller, 'show')
      contextBtn.click()
      expect(controller.show).toHaveBeenCalled()
    
    it 'invokes show when a simple [element] is clicked', ->
      context = $('<div>Foo</div>')
      controller  = new PopupController context, popup
      spyOn(controller, 'show')
      context.click()
      expect(controller.show).toHaveBeenCalled()
      
      
      
      
    
    
    it 'does not show when a disabled [View] is clicked', ->
      spyOn(controller, 'show')
      context.enabled false
      context.el.click()
      expect(controller.show).not.toHaveBeenCalled()
      
      
      
      
    
    
      
      
    
    
      
    
    
  






