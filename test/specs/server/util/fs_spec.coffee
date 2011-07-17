xdescribe 'server/util/fs', ->
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


