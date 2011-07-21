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


