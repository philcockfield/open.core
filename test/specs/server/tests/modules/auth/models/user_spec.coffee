mongoose = require 'mongoose'

describe 'modules/auth/models/user', ->
  module = null
  User   = null
  
  beforeEach ->
    module = new core.modules.Auth().init( keys:test.authKeys )
    User = module.models.User
  
  it 'exists', -> expect(User).toBeDefined()
  
    
    
  
  
    
  
  
  
  
  
  