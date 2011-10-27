describe 'Test Harness', ->
  
  beforeAll ->
      page.pane.show()
  
  it 'Pane: Show', -> page.pane.show()
  it 'Pane: Hide', -> page.pane.hide()
  