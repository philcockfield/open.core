describe 'Controllers', ->
  describe 'Popup Controller', ->
    view = null
    
    beforeAll ->
      view = new test.Dummy()
      page.add view, width: 100, height:60
      
    
