describe 'Controls', 
  '''
  Controls are visual elements that encapsulate a piece of common UI behavior behind an API.
  ''',
  sortSuites: true, ->
    
    describe 'Buttons', ->
      describe 'Command (CmdButton)', ->
        buttons   = []
        addCmdButton = (options) -> 
          btn = new controls.CmdButton options
          page.add btn
          buttons.push btn
          btn.onClick (e) -> console.log 'onClick: ', e.source.label(), e
          # btn.bind 'stateChanged', (e) -> console.log 'stateChanged: ', e.source.label(), e, e.state
          btn.bind 'selected', (e) -> console.log 'selected: ', e.source.label(), e.source.selected()
          btn
        
        beforeAll -> 
          btn = addCmdButton label:'My Label'
          btn.el.attr 'id', 'cmd_btn'
        
        it 'Add another',   -> addCmdButton label:"Button #{buttons.length + 1}"
        it 'Color: Blue',   -> btn.color 'blue' for btn in buttons
        it 'Color: Silver', -> btn.color 'silver' for btn in buttons
        it 'Width: 200',    -> btn.width 200 for btn in buttons
        it 'Width: null',   -> btn.width null for btn in buttons
        
      
        describe 'ButtonSet', ->
          buttonSet = null
          
          addToSet = (options = {}) -> 
            options.canToggle = true
            btn = addCmdButton options
            buttonSet.add btn
            btn
          
          beforeAll ->
            page.reset()
            buttonSet = new controls.ButtonSet()
            for label in ['One', 'Two', 'Three']
              addToSet label:label
      
      
      describe 'Toggle Buttons', ->
        describe 'Checkbox', ->
          chk = null
          beforeAll -> chk = page.add new controls.Checkbox label:'My Checkbox'
        
        describe 'RadioButton', ->
          rdo = null
          beforeAll -> rdo = page.add new controls.RadioButton label:'My Radio Button'
        
        addButtonToSet = (buttonSet, prefix = 'Option') -> buttonSet.add label:"#{prefix} #{buttonSet.count() + 1}"
        initButtonSet = (buttonSet) -> 
              page.add buttonSet
              addButtonToSet(buttonSet) for i in [1,2,3]
              buttonSet.bind 'selectionChanged', (e) -> console.log 'EVENT: selectionChanged', e
              buttonSet
        
        describe 'CheckboxSet', ->
          chkSet = null
          beforeAll -> chkSet = initButtonSet new controls.CheckboxSet()
          
          it 'add', -> addButtonToSet(chkSet)
          it 'orientation: X', -> chkSet.orientation 'x'
          it 'orientation: Y (default)', -> chkSet.orientation 'y'
          it 'init', ->
            chkSet.init [
              { label: 'Egocentric', selected:true }
              { label: 'Ethnocentric' }
              { label: 'Worldcentric', selected:true }
            ]
          it 'clear', -> chkSet.clear()
          it 'remove first', -> chkSet.remove chkSet.controls.first()
        
        describe 'RadioButtonSet', ->
          rdoSet = null
          beforeAll -> 
            rdoSet = initButtonSet new controls.RadioButtonSet()
            rdoSet.buttons.first().selected true          
            
            page.pane.add.markdown
              label:'Sample Code'
              markdown:
                '''
                    :coffee
                    # Create the control.
                    controls = require 'open.client/controls'
                    rdoSet   = new controls.RadioButtonSet()
                    
                    # Initialize a set of buttons.
                    rdoSet.init [
                      { label: 'Egocentric' }
                      { label: 'Ethnocentric' }
                      { label: 'Worldcentric', selected:true }
                    ]
                
                '''
              
          it 'add', -> addButtonToSet(rdoSet)
          it 'orientation: X', -> rdoSet.orientation 'x'
          it 'orientation: Y (default)', -> rdoSet.orientation 'y'
          it 'select first', -> rdoSet.buttons.first().selected true
          it 'select last', -> rdoSet.buttons.last().selected true
          it 'init', ->
            rdoSet.init [
              { label: 'Egocentric' }
              { label: 'Ethnocentric' }
              { label: 'Worldcentric', selected:true }
            ]
          it 'clear', -> rdoSet.clear()
          it 'remove first', -> rdoSet.remove rdoSet.buttons.first()
          
          
    describe 'TabStrip', ->
      tabStrip = null
      beforeAll ->
          tabStrip = new controls.TabStrip()
          page.add tabStrip, width:'80%', border:true

          add() for i in [1..4]
          tabStrip.first().click()
          tabStrip.last().enabled false
          tabStrip.tabs.bind 'selectionChanged', (e) -> console.log 'SELECTION CHANGED:', e.button.label(), e
      
      add = -> tabStrip.add label:"Tab #{tabStrip.count() + 1}"
      
      it 'Add', -> add()
      it 'Toggle Enabled (First)', -> 
          firstTab = tabStrip.tabs.first()
          if firstTab?
              firstTab.enabled not firstTab.enabled()
              console.log 'Enabled: ', firstTab.enabled()
          
      it 'Remove (First)', -> tabStrip.remove tabStrip.tabs.first()
      it 'Clear', -> tabStrip.clear()
      it 'Change Label', ->
        tab = tabStrip.tabs.first()
        tab.label 'New Label' if tab?
      
      it 'Init', ->
        tabStrip.init [
          { label:'One' }
          { label:'Two' }
          { label:'Three', enabled:false }
        ]
  
  
    describe 'Textbox', ->
      textbox = null
      beforeAll ->
          textbox = new controls.Textbox watermark:'Watermark'
          page.add textbox, width:300
      it 'Focus', -> textbox.focus()
    
    describe 'Form', ->
      form = null
      beforeAll ->
          form = new controls.Form()
          page.add form, width:550
    
    describe 'ComboBox', ->
      cbo = null
      beforeAll ->
          cbo = new controls.ComboBox()
          page.add cbo, width:280
          cbo.add 'One'
          cbo.add 'Two'
          cbo.add label:'Three', selected:true
      
      it 'Toggle: enabled', -> cbo.enabled.toggle()
      it 'add', -> cbo.add "Item #{cbo.items.length + 1}"
      
      it 'select:first', -> 
        item = cbo.items.first()
        item?.selected true
        
      it 'select:last', -> cbo.selected cbo.items.last()
      
      it 'init', ->
        cbo.init [
          { label:'Apple' }
          { label:'Bannana' }
          { label:'Zebra' }
        ]
      
      it 'read properties', ->
        console.log 'cbo.selected()', cbo.selected(), cbo.selected()?.label()
      
      
      
  