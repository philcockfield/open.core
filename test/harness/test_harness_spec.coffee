describe 'Test Harness', ->

  it 'show pane', -> page.contextPane.visible true
  it 'hide pane', -> page.contextPane.visible false
  