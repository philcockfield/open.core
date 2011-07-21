describe 'server/util/fs', ->
  sampleDir = "#{__dirname}/sample"
  paths     = test.paths
  fsUtil    = test.server.util.fs

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
    includes = (paths, file) -> _.any paths, (p) -> _.endsWith(p, file)
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
        expect(includes(result, '.hidden')).toEqual false
        expect(includes(result, 'dir')).toEqual false

        expect(includes(result, ".hidden.txt")).toEqual true
        expect(includes(result, "file1.txt")).toEqual true
        expect(includes(result, "file2.txt")).toEqual true


    it 'includes folders but not files', ->
      result = null
      fsUtil.readDir path, files:false, (err, paths) -> result = paths
      waitsFor -> result?
      runs ->
        expect(includes(result, '.hidden')).toEqual true
        expect(includes(result, 'dir')).toEqual true

        expect(includes(result, ".hidden.txt")).toEqual false
        expect(includes(result, "file1.txt")).toEqual false
        expect(includes(result, "file2.txt")).toEqual false

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
        expect(includes(result, '.hidden')).toEqual false
        expect(includes(result, ".hidden.txt")).toEqual false

        expect(includes(result, 'dir')).toEqual true
        expect(includes(result, "file1.txt")).toEqual true
        expect(includes(result, "file2.txt")).toEqual true


  describe 'flattenDir', ->
    path = null
    includes = (paths, file) -> _.any paths, (p) -> _.endsWith(p, file)
    beforeEach ->
      path = "#{sampleDir}/flatten_dir"




