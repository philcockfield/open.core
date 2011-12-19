describe 'Controls', 
  '''
  controls are visual elements that encapsulate a piece of common UI behavior behind an API.
  ''',
  sortSuites:true, ->
    beforeAll -> page.pane.reset()
    
    
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
        
        it 'Add: Blue',      -> addCmdButton label:"Button #{buttons.length + 1}", color:'blue'
        it 'Add: Silver',    -> addCmdButton label:"Button #{buttons.length + 1}"
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
          

      describe 'IconButton', ->
        btn = null
        FOLDER = '/images/test/controls/icon_button'
        ICONS =
          warning:
            url: "#{FOLDER}/warning.png"
            css: 'icon_warning'
          accept:
            url: "#{FOLDER}/accept.png"
            css: 'icon_accept'
        
        icon = null
        beforeAll ->
          icon = add()
          icon = add()
          
          page.pane.add.markdown
            label:'Sample Code'
            markdown:
              '''
                  :coffee
                  controls = require 'open.client/controls'
                  
                  # Create the control referencing a loose image file as the icon.
                  btn = new controls.IconButton 
                    label:    'My Label'
                    icon:     '/images/my_icon.png'
                    iconType: 'url' # default
                  
                  # An icon can also be referenced as a CSS class when the image
                  # is embedded within the stylesheet (see below).
                  btn = new controls.IconButton 
                    label:    'My Label'
                    icon:     'icon_class_name'
                    iconType: 'css'
                  
              
              Embedding images in CSS can be achieved using the [data-URI](http://en.wikipedia.org/wiki/Data_URI_scheme) scheme.
              
                  :css
                  .icon_class_name {
                    background-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEU ... etc");
                  }
              
              See the `toDataUris()` method (in `server/util/tasks/css`) for converting a folder of images to 
              [Stylus](http://learnboost.github.com/stylus/docs/js.html) constants containing data-URI's for each image file.
              
              '''          
          page.pane.add.css
            label: 'CSS'
            url:   '/stylesheets/core/controls/buttons/icon.css'
          page.pane.add.remote 
            label: 'Test CSS'
            url:   '/stylesheets/dev/test.css'
        
        changeIconType = (type) -> 
          page.el.html ''
          add iconType: type
          add iconType: type
        
        changeIcon = (iconSample) -> 
          value = if btn.iconType() is 'url' then iconSample.url else iconSample.css
          btn.icon value
          btn
          
        
        add = (params = {})-> 
          params.label ?= "My Label #{page.el.children().length + 1}"
          params.icon ?= if params.iconType is 'css' then ICONS.accept.css else ICONS.accept.url
          
          btn = new controls.IconButton params
          page.add btn, className:'test_icon'
          btn.onClick (e) -> console.log 'onClick: ', e.source.label(), e
          btn
        
        it 'Toggle: enabled', -> btn.enabled.toggle()
        it 'Add new', -> add()
        it 'Change: label', -> btn.label new Date().getTime()
        it 'Change: iconType - url', -> changeIconType 'url'
        it 'Change: iconType - css', -> changeIconType 'css'
        it 'Icon: Accept (url)', -> changeIcon ICONS.accept
        it 'Icon: Warning (url)', -> changeIcon ICONS.warning
        it 'Set: tooltip', -> btn.tooltip 'A tooltip value \nover two lines'
        it 'Change: labelOffset', -> btn.labelOffset x:15, y:-5
        it 'Change: iconOffset', -> btn.iconOffset x:7, y:-15
        it 'Change: iconSize', -> btn.iconSize x:30, y:30
        
          
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
          textbox = add()
      
      add = -> 
        textbox = new controls.Textbox prompt:'Prompt Watermark'
        page.add textbox, width:300, className:'test_textbox'
        textbox
      
      it 'Focus', -> textbox.focus()
      it 'Change prompt', -> textbox.prompt 'New Prompt (example.com)'
      it 'Add new', -> add()
    
    
    describe 'ComboBox', ->
      cbo = null
      beforeAll ->
          cbo = new controls.ComboBox()
          page.add cbo, width:280
          cbo.add 'One'
          cbo.add 'Two'
          cbo.add label:'Three', selected:true
          
          page.pane.add.markdown
            label:  'Sample Code'
            clear:  true
            markdown: 
              '''
              # Creating and working with the ComboBox
                  :coffee
                  # Construction.
                  controls = require 'open.client/controls'
                  cbo = new controls.ComboBox()
              
                  # Adding
                  item1 = cbo.add 'One'                         # Adds an item with a label only
                  item2 = cbo.add label:'Two', value:1234       # Adds an item wiht a label and value
                  item3 = cbo.add label:'Three', selected:true  # This item is selected (default is first item)
              
                  # The returned items are models with 'label', 'value' and 'selected' property functions.
                  # Changing these properties will update the list item within the control, eg.
                  item1.label 'Foo'
                  item1.value true
                  item1.selected true # Selects the item, cbo.selected() is not set to [item1]
              
                  # Selection.
                  # As well as setting the [selected] property on the item model, you can set the 
                  # root [selected] property on the ComboBox.
              
                  cbo.selected item2  # item2.selected() now equals true
                  cbo.selected 0      # You can also pass an index, which converts it to the model.
                                      # The return value after setting with an index is still the corresponding Item model.
              
                  # Working with items.
                  item1 = cbo.item(0) # Retrieve the item at the given index.
                  cbo.items.each (item) -> # Loop over all items.
              
                  # Adding with init method - does the same as the first initialization.
                  # Calling init will clear any existing items.
                  cbo.init [
                    { label:'One' }
                    { label:'Two', value:1234 }
                    { label:'Three', selected:true }
                  ]
                  
                  # Removing and clearing.
                  cbo.remove 0      # Removes the first item
                  cbo.remove item2  # Removes the specified item model.
                  cbo.clear()       # Removes all items.
              
              
              ### Using the init() method.
                  :coffee
                  cbo = new controls.ComboBox().init [
                    { label:'One' }
                    { label:'Two', value:1234 }
                    { label:'Three', selected:true }
                  ]
              
              '''
      
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
    
    
    describe 'Popup', ->
      popup = null
      beforeAll ->
        popup = new controls.Popup width:300, height:250
        page.add popup
        
        page.pane.reset()
        page.pane.add.css
          label: 'CSS'
          url:   '/stylesheets/core/controls/popup.css'
      
      it 'Smaller size: 250 x 100', -> 
        popup.width 250
        popup.height 100
      
      it 'Anchor: n',  -> popup.anchor 'n'
      it 'Anchor: s',  -> popup.anchor 's'
      it 'Anchor: w',  -> popup.anchor 'w'
      it 'Anchor: e',  -> popup.anchor 'e'
      it 'Anchor: ne', -> popup.anchor 'ne'
      it 'Anchor: nw', -> popup.anchor 'nw'
      it 'Anchor: en', -> popup.anchor 'en'
      it 'Anchor: es', -> popup.anchor 'es'
      it 'Anchor: wn', -> popup.anchor 'wn'
      it 'Anchor: ws', -> popup.anchor 'ws'
      it 'Anchor: se', -> popup.anchor 'se'
      it 'Anchor: sw', -> popup.anchor 'sw'
        
      
      
      
  