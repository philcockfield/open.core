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
        describe 'Checkbox', ->
          chk = null
          beforeAll -> chk = page.add new controls.Checkbox label:'My Checkbox'
        
        describe 'RadioButton', ->
          rdo = null
          beforeAll -> rdo = page.add new controls.RadioButton label:'My Radio Button'
        
        describe 'RadioButtonSet', ->
          rdoSet = null
          beforeAll ->
              rdoSet = page.add new controls.RadioButtonSet()
              add()
              add()
              add()
              rdoSet.buttons.first().selected true
              rdoSet.bind 'selectionChanged', (e) -> console.log 'EVENT: selectionChanged', e
          
          add = -> rdoSet.add label:"Option #{rdoSet.count() + 1}"
          
          it 'add', -> add()
          it 'orientation: x', -> rdoSet.orientation 'x'
          it 'orientation: y', -> rdoSet.orientation 'y'
          it 'select first', -> rdoSet.buttons.first().selected true
          it 'select last', -> rdoSet.buttons.last().selected true
          
          
          
        

  
  
    describe 'Textbox', ->
      textbox = null
      beforeAll ->
          textbox = new controls.Textbox watermark:'Watermark'
          page.add textbox, width:300
      
      it 'Focus', -> textbox.focus()
      
        
        
      
  
  
  
  