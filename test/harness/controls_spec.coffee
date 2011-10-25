describe 'Controls', 
  '''
    Controls are visual elements that encapsulate a piece of common UI behavior behind an API.
  ''',
  ->
    beforeAll ->
        page.css '/stylesheets/core/base.css',
                 '/stylesheets/core/controls.css'
    
    
    describe 'Buttons', ->
      describe 'Command (CmdButton)', ->
        buttons   = []
        addButton = (options) -> 
            btn = new controls.CmdButton options
            page.add btn
            buttons.push btn
            btn.onClick (e) -> console.log 'CLICK: ', e.source.label(), e
            btn
        
        beforeAll -> addButton label:'My Label'
        
        it 'Add another', -> addButton label:"Button #{buttons.length + 1}"
        it 'Color: Blue', -> btn.color 'blue' for btn in buttons
        it 'Color: Silver', -> btn.color 'silver' for btn in buttons
      
      describe 'Toggle Buttons', ->
        describe 'RadioButton', ->
          rdo = null
          beforeAll ->
              rdo = new controls.RadioButton label:'My Radio Button'
              page.add rdo

        describe 'Checkbox', ->
          chk = null
          beforeAll ->
              chk = new controls.Checkbox label:'My Checkbox'
              page.add chk

  
  
    describe 'Textbox', ->
      textbox = null
      beforeAll ->
          textbox = new controls.Textbox watermark:'Watermark'
          page.add textbox, width:300
      
      it 'Focus', -> textbox.focus()
      
        
        
      
  
  
  
  