describe 'common_js', ->
  
  describe 'retrieving modules', ->
    it 'retrieves module at specific path', ->
      module = require 'core/test/common_js/module1/foo'
      expect(module.name).toEqual 'Foo (Module1)'
  
    it 'retrieves the module index', ->
      module = require 'core/test/common_js'
      index = require 'core/test/common_js/index'
      expect(module).toEqual index
  
  describe 'relative paths', ->
    it 'retrieves module using relative path', ->
      module1 = require 'core/test/common_js/module1'
      foo     = require 'core/test/common_js/module1/foo'
      expect(module1.foo).toEqual foo
  
    it 'retrieves modules with the same name, in different folders, via a relative path', ->
      # Ensure caching works.  This was a bug in the origina Stitch code.
      module1 = require 'core/test/common_js/module1'
      module2 = require 'core/test/common_js/module2'
      expect(module1.foo).not.toEqual module2.foo
    
    it 'retrieves a module from a relative child folder [./folder/child]', ->
      module1 = require 'core/test/common_js/module1'
      child   = require 'core/test/common_js/module1/folder/child'
      expect(module1.child).toEqual child

    it 'retrieves an index from a relative child folder [./folder/child]', ->
      module1 = require 'core/test/common_js/module1'
      child   = require 'core/test/common_js/module1/folder/child'
      expect(module1.folder.child).toEqual child
    
  
  describe 'relative paths with back steps [../]', ->
    it 'retrieves a path walking up the tree starting with a relative path [../]', ->
      module2 = require 'core/test/common_js/module2'
      bar1    = require 'core/test/common_js/module1/bar'
      expect(module2.bar1).toEqual bar1
    
    it 'walks up one level', ->
      module1 = require 'core/test/common_js'
      module2 = require 'core/test/common_js/module2/../index'
      expect(module1).toEqual module2

    it 'walks up three levels', ->
      module1 = require 'core/test/common_js'
      module2 = require 'core/test/common_js/module2/one/two/../../../index'
      expect(module1).toEqual module2
