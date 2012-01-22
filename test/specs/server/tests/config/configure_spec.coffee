express = require 'express'
core    = test.server

describe 'config/configure', ->
  app = null
  beforeEach ->
    app = express.createServer()

  describe 'baseUrl', ->
    it 'stores the base url on [server]', ->
      core.init app, baseUrl: '/abc', -> 
      expect(core.baseUrl).toEqual '/abc'

    it 'turns "/" into empty empty string', ->
      core.init app, baseUrl: '/', -> 
      expect(core.baseUrl).toEqual ''

    it 'turns padded "/" into empty empty string', ->
      core.init app, baseUrl: '  /  ', -> 
      expect(core.baseUrl).toEqual ''






