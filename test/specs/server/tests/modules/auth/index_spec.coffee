mongoose = require 'mongoose'


describe 'modules/auth/index (root module)', ->
  Auth   = null
  auth   = null
  
  beforeEach ->
    Auth = core.modules.Auth
    auth = new Auth()
  
  it 'exists', -> expect(Auth).toBeDefined()
  
  it 'is an MVC Module', ->
    expect(auth instanceof core.mvc.Module).toEqual true 
  
  
  describe 'init()', ->
    it 'returns the module', ->
      auth = new Auth()
      expect(auth.init( keys:test.authKeys )).toEqual auth




