describe 'Test Harness', ->
  
  describe 'Pane', ->
    pane = null
    beforeAll -> 
        pane = page.pane
        pane.show()
  
    it 'Show', -> pane.show()
    it 'Hide', -> pane.hide()
    it 'Height: 20', -> pane.height 20
    it 'Height: 200', -> pane.height 200
    
  
  