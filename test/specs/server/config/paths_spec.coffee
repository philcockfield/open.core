describe 'config/paths', ->

  describe 'global paths', ->
    it 'puts [server] into the global paths', ->
      module = require 'core.server'
      expect(module.paths).toEqual test.paths

    it 'puts [client] into the global paths', ->
      module = require 'core.client'
      expect(module).toBeDefined()

