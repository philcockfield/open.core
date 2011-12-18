describe 'controls/controllers/popup', ->
  PopupController = null
  controller      = null
  context         = null
  popupView       = null
  
  fnPopup = -> 
    popupView = new core.mvc.View()
  
  
  beforeEach ->
    PopupController = controls.controllers.Popup
    context         = new core.mvc.View()
    popup           = new core.mvc.View()
    controller      = new PopupController context, fnPopup
  
  it 'exists', ->
    expect(PopupController).toBeDefined()
  
  describe 'element extraction', ->
    describe 'from views', ->
      beforeEach ->
        controller = new PopupController context, fnPopup
      
      it 'exposes the context element', ->
        expect(controller.elContext).toEqual context.el
    
    describe 'from jQuery elements', ->
      beforeEach ->
        controller = new PopupController context.el, fnPopup
        
      it 'exposes the context element', ->
        expect(controller.elContext).toEqual context.el
  
  describe 'show()', ->
    it 'invokes show when element is clicked', ->
      spyOn(controller, 'show')
      context.el.click()
      expect(controller.show).toHaveBeenCalled()
    
    it 'invokes show when a [Button] is clicked', ->
      contextBtn  = new controls.CmdButton()
      controller  = new PopupController contextBtn, fnPopup
      spyOn(controller, 'show')
      contextBtn.click()
      expect(controller.show).toHaveBeenCalled()
    
    it 'invokes show when a simple [element] is clicked', ->
      context = $('<div>Foo</div>')
      controller  = new PopupController context, fnPopup
      spyOn(controller, 'show')
      context.click()
      expect(controller.show).toHaveBeenCalled()
      
    it 'does not show when a disabled [View] is clicked', ->
      spyOn(controller, 'show')
      context.enabled false
      context.el.click()
      expect(controller.show).not.toHaveBeenCalled()
      
  
  describe 'isShowing()', ->
    it 'reports as showing', ->
      controller.show()
      expect(controller.isShowing()).toEqual true

    it 'reports as not showing by default', ->
      expect(controller.isShowing()).toEqual false
      
    it 'reports as not showing after being hidden', ->
      controller.show()
      controller.hide()
      expect(controller.isShowing()).toEqual false
    
      
      
      
    
    
      
      
    
    
      
    
    
  






