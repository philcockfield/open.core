describe 'Modules', ->
  describe 'Auth', 'Authentication and authorization UI module.', ->
    auth = null
    beforeAll ->
        Auth = require 'open.client/auth'
        auth = new Auth()
        auth.init()
        page.add auth.rootView, fill:true
    
  