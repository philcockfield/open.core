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
    
    describe 'Hiding', ->
      it 'hides the popup by default on an element', ->
        popup = new core.mvc.View()
        new PopupController context, popup.el
        expect(_(popup.outerHtml()).includes('display: none;')).toEqual true
      
      it 'hides the popup by changing the view visibility', ->
        expect(popup.visible()).toEqual false
        expect(_(popup.outerHtml()).includes('display: none;')).toEqual true






