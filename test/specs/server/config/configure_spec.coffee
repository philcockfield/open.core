express = require 'express'
core    = require('core.server')

describe 'config/configure', ->
  app = null
  beforeEach ->
    app = express.createServer()

  describe 'baseUrl', ->
    it 'stores the base url on [core.server]', ->
      core.configure app, baseUrl: '/abc'
      expect(core.baseUrl).toEqual '/abc'

    it 'turns "/" into empty empty string', ->
      core.configure app, baseUrl: '/'
      expect(core.baseUrl).toEqual ''

    it 'turns padded "/" into empty empty string', ->
      core.configure app, baseUrl: '  /  '
      expect(core.baseUrl).toEqual ''














