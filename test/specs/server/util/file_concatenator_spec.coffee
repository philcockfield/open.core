describe 'server/util/file_contatenator', ->
  core = test.server
  FileConcatenator = core.util.javascript.FileConcatenator

  it 'exists of the util index', ->
    expect(core.util.javascript.FileConcatenator).toBeDefined()


  describe 'constructor', ->
    it 'stores the paths', ->
      instance = new FileConcatenator(['file.js'])
      expect(instance.paths).toEqual ['file.js']

    it 'turns a single path into an array', ->
      instance = new FileConcatenator('file.js')
      expect(instance.paths).toEqual ['file.js']

      

      

