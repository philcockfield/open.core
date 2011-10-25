describe 'Controls', 
  '''
    Controls are visual elements that encapsulate a piece of common UI behavior behind an API.
  ''',
  ->
    beforeAll ->
        page.css '/stylesheets/core/base.css',
                 '/stylesheets/core/controls.css'
    
    
    describe 'Buttons', ->
      describe 'Command Button', ->
        CmdButton = null
        buttons   = []
        
        addButton = (options) -> 
            btn = new CmdButton options
            page.add btn
            buttons.push btn
            btn.onClick (e) -> console.log 'CLICK: ', e.source.label(), e
            btn
        
        beforeAll ->
            CmdButton = controls.CmdButton
            addButton label:'My Label'
        
        it 'Add another', -> addButton label:"Button #{buttons.length + 1}"
        it 'Color: Blue', -> btn.color 'blue' for btn in buttons
        it 'Color: Silver', -> btn.color 'silver' for btn in buttons
  
    describe 'Textbox', ->
      textbox = null
      beforeAll ->
          textbox = new controls.Textbox watermark:'Watermark'
          page.add textbox, width:300
      
      it 'Focus', ->
        textbox.focus()
      
      
      
        
          
      
  
  
  
  