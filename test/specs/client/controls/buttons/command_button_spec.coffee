describe 'controls/buttons/command_button', ->
  CommandButton = null
  button = null
  beforeEach ->
      CommandButton = controls.CommandButton
      button = new CommandButton()
      
  
  it 'exists', ->
    expect(CommandButton).toBeDefined()
    
  it 'dervies from [Button]', ->
    expect(button instanceof controls.Button).toEqual true 
  
  