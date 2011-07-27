describe 'server/util/fs', ->
  sampleDir = "#{__dirname}/sample"
  paths     = test.paths
  fsUtil    = test.server.util.fs
  fs        = require 'fs'
  fsPath    = require 'path'
  createEmptyFolder = (path) ->
          # Creating empty folders for tests is needed
          # because Git does not store empty folders.
          return if fsPath.existsSync(path)
          fs.mkdirSync path, 0777
  createEmptyFolder("#{sampleDir}/empty")


  includesPath = (paths, file) -> _.any paths, (p) -> _.endsWith(p, file)
  includesAllPaths = (paths, files) ->
      for file in files
          return false if not includesPath paths, file
      true


  it 'is available from the util module', ->
    expect(test.server.util.fs).toBeDefined()


  describe 'parentDir', ->
    it 'retrieves the parent directory', ->
      path = '/foo/bar/bas.txt'
      expect(fsUtil.parentDir(path)).toEqual '/foo/bar'

    it 'retrieves the parent directory from leading slash', ->
      path = '/foo/bar/'
      expect(fsUtil.parentDir(path)).toEqual '/foo'

    it 'retrieves the parent directory with no leading slash', ->
      path = '/foo/bar'
      expect(fsUtil.parentDir(path)).toEqual '/foo'

    it 'has no parent directory when / only', ->
      path = '/'
      expect(fsUtil.parentDir(path)).toEqual null

    it 'has no parent directory when empty', ->
      path = ''
      expect(fsUtil.parentDir(path)).toEqual null

    it 'has no parent directory when white space', ->
      path = '    '
      expect(fsUtil.parentDir(path)).toEqual null

    it 'has no parent directory when null', ->
      path = null
      expect(fsUtil.parentDir(path)).toEqual null

    it 'has no parent directory when at root', ->
      path = '/foo'
      expect(fsUtil.parentDir(path)).toEqual null

    it 'has no parent directory when at root (padded)', ->
      path = '  /foo  '
      expect(fsUtil.parentDir(path)).toEqual null


  describe 'isHidden', ->
    it 'is hidden', ->
      expect(fsUtil.isHidden('.foo')).toEqual true

    it 'is not hidden', ->
      expect(fsUtil.isHidden('foo')).toEqual false

    it 'is not hidden when null', ->
      expect(fsUtil.isHidden()).toEqual false
      expect(fsUtil.isHidden(null)).toEqual false
      expect(fsUtil.isHidden(undefined)).toEqual false


  describe 'readDir', ->
    path = null
    beforeEach ->
      path = "#{sampleDir}/read_dir"

    it 'reads all content', ->
      result = null
      fsUtil.readDir path, (err, paths) -> result = paths
      waitsFor -> result?
      runs -> expect(result.length).toEqual 5

    it 'expands paths', ->
      result = null
      fsUtil.readDir path, (err, paths) -> result = paths
      waitsFor -> result?
      runs ->
        expect(result[0]).toEqual "#{path}/.hidden"


    it 'includes files but not folders', ->
      result = null
      fsUtil.readDir path, dirs:false, (err, paths) -> result = paths
      waitsFor -> result?
      runs ->
        expect(includesPath(result, '.hidden')).toEqual false
        expect(includesPath(result, 'dir')).toEqual false

        expect(includesPath(result, ".hidden.txt")).toEqual true
        expect(includesPath(result, "file1.txt")).toEqual true
        expect(includesPath(result, "file2.txt")).toEqual true


    it 'includes folders but not files', ->
      result = null
      fsUtil.readDir path, files:false, (err, paths) -> result = paths
      waitsFor -> result?
      runs ->
        expect(includesPath(result, '.hidden')).toEqual true
        expect(includesPath(result, 'dir')).toEqual true

        expect(includesPath(result, ".hidden.txt")).toEqual false
        expect(includesPath(result, "file1.txt")).toEqual false
        expect(includesPath(result, "file2.txt")).toEqual false

    it 'includes neither folders or files (nothing)', ->
      result = null
      fsUtil.readDir path, files:false, dirs:false, (err, paths) -> result = paths
      waitsFor -> result?
      runs ->
        expect(result.length).toEqual 0

    it 'does not include hidden items', ->
      result = null
      fsUtil.readDir path, hidden:false, (err, paths) -> result = paths
      waitsFor -> result?
      runs ->
        expect(includesPath(result, '.hidden')).toEqual false
        expect(includesPath(result, ".hidden.txt")).toEqual false

        expect(includesPath(result, 'dir')).toEqual true
        expect(includesPath(result, "file1.txt")).toEqual true
        expect(includesPath(result, "file2.txt")).toEqual true


  describe 'flattenDir', ->
    path = null
    beforeEach ->
        path = "#{sampleDir}/flatten_dir"
        createEmptyFolder "#{path}/empty"
        createEmptyFolder "#{path}/folder/empty"

    it 'flattens entire directory structure (excluding empty folders)', ->
      result = null
      fsUtil.flattenDir path, (err, paths) -> result = paths
      waitsFor -> result?
      runs ->
        expected = [
          '/.hidden/file.txt'
          '/folder/child/child.txt'
          '/folder/file1.txt'
          '/folder/file2.txt'
          '.hidden.txt'
          'file.txt'
        ]
        expect(includesAllPaths(result, expected)).toEqual true

    it 'flattens entire directory structure not includeing hidden files', ->
      result = null
      fsUtil.flattenDir path, hidden:false, (err, paths) -> result = paths
      waitsFor -> result?
      runs ->
        expected = [
          '/folder/child/child.txt'
          '/folder/file1.txt'
          '/folder/file2.txt'
          'file.txt'
        ]
        notExpected = [
          '/.hidden/file.txt'
          '.hidden.txt'
        ]
        expect(includesAllPaths(result, expected)).toEqual true
        expect(includesAllPaths(result, notExpected)).toEqual false

  describe 'writeFile', ->
    path = null
    dir = null
    file1 = null
    file2 = null
    deleteSample = -> 
        tryTo = (fn) -> 
            try
              fn()
            catch error
        tryTo -> fs.unlinkSync file1
        tryTo -> fs.unlinkSync file2
        tryTo -> fs.rmdirSync dir
    
    beforeEach ->
        dir  = "#{sampleDir}/writeFile/folder"
        file1 = "#{dir}/file1.txt"
        file2 = "#{dir}/file2.txt"
        deleteSample()
        
    it 'write a single file creating the containing directory', ->
      result = null
      fsUtil.writeFile file1, 'Hello!', (err) -> result = true
      waitsFor -> result?
      runs ->
          data = fs.readFileSync(file1)
          expect(data.toString()).toEqual 'Hello!'
          deleteSample()

    it 'write a single file creating the containing directory', ->
      result = null
      files = [
          { path:file1, data:'Hello1' }
          { path:file2, data:'Hello2' }
        ]
      
      fsUtil.writeFiles files, (err) -> result = true
      waitsFor -> result?
      runs ->
          expect(fs.readFileSync(file1).toString()).toEqual 'Hello1'
          expect(fs.readFileSync(file2).toString()).toEqual 'Hello2'
          deleteSample()
        
      
    
    
    
    
    
    
    
    
    
    