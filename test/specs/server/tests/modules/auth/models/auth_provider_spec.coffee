mongoose = require 'mongoose'
util     = require 'util'


describe 'modules/auth/models/auth_provider', ->
  module       = null
  AuthProvider = null
  
  beforeEach ->
    module       = new core.modules.Auth().init( keys:test.authKeys )
    AuthProvider = module.models.AuthProvider
  
  it 'exists', -> expect(AuthProvider).toBeDefined()
  
