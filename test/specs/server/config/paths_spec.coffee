describe 'config/paths', ->

  describe 'global paths', ->
    it 'puts [server] into the global paths', ->
      module = require 'open.server'
      expect(module.paths).toEqual test.paths

    it 'puts [client] into the global paths', ->
      module = require 'open.client'
      expect(module).toBeDefined()

