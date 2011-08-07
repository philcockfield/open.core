describe 'util/fs', ->
  sampleDir = "#{__dirname}/sample"
  paths     = test.paths
  fsUtil    = test.server.util.fs
  fs        = require 'fs'
  fsPath    = require 'path'
  tryTo = (fn) -> 
      try
        fn()
      catch error
  createEmptyFolder = (path) ->
          # Creating empty folders for tests is needed
          # because Git does not store empty folders.
          return if fsPath.existsSync(path)
          fs.mkdirSync path, 0777
  createEmptyFolder("#{sampleDir}/empty")

  includesPath = (paths, file) -> _.any paths, (p) -> _.endsWith(p, file)
  includesAllPaths = (paths, files) ->
      for file in files
          return false if not includesPath(paths, file)
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

    describe 'async', ->
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

      describe 'deep read', ->
        it 'reads only the current level if deep but dirs:false', ->
          result = null
          fsUtil.readDir path, dirs:false, deep:true, (err, paths) -> result = paths
          waitsFor -> result?
          runs ->
            expect(includesPath(result, '.hidden')).toEqual false
            expect(includesPath(result, 'dir')).toEqual false
            expect(includesPath(result, ".hidden.txt")).toEqual true
            expect(includesPath(result, "file1.txt")).toEqual true
            expect(includesPath(result, "file2.txt")).toEqual true
      
        it 'reads deep file path with hidden files', ->
          result = null
          fsUtil.readDir path, deep:true, (err, paths) -> result = paths
          waitsFor (-> result?), 100
          runs ->
            expect(includesPath(result, '.hidden')).toEqual true
            expect(includesPath(result, '.hidden/file.txt')).toEqual true
            expect(includesPath(result, ".hidden.txt")).toEqual true
            expect(includesPath(result, 'dir')).toEqual true
            expect(includesPath(result, 'dir/file.txt')).toEqual true
            expect(includesPath(result, 'dir/child/grandchild1.txt')).toEqual true
            expect(includesPath(result, 'dir/child/grandchild2.txt')).toEqual true
            expect(includesPath(result, "file1.txt")).toEqual true
            expect(includesPath(result, "file2.txt")).toEqual true
                  
        it 'reads deep file path with folders only', ->
          result = null
          fsUtil.readDir path, deep:true, files:false, (err, paths) -> result = paths
          waitsFor (-> result?), 100
          runs ->
            expect(includesPath(result, '.hidden')).toEqual true
            expect(includesPath(result, '.hidden/file.txt')).toEqual false
            expect(includesPath(result, ".hidden.txt")).toEqual false
            expect(includesPath(result, 'dir')).toEqual true
            expect(includesPath(result, 'dir/file.txt')).toEqual false
            expect(includesPath(result, 'dir/child/grandchild1.txt')).toEqual false
            expect(includesPath(result, 'dir/child/grandchild2.txt')).toEqual false
            expect(includesPath(result, "file1.txt")).toEqual false
            expect(includesPath(result, "file2.txt")).toEqual false

      
    describe 'synchronous', ->
      it 'reads all content', ->
        result = fsUtil.readDirSync path
        expect(result.length).toEqual 5

      it 'expands paths', ->
        result = fsUtil.readDirSync path
        expect(result[0]).toEqual "#{path}/.hidden"
      
      it 'includes files but not folders', ->
        result = fsUtil.readDirSync path, dirs:false
        expect(includesPath(result, '.hidden')).toEqual false
        expect(includesPath(result, 'dir')).toEqual false
        expect(includesPath(result, ".hidden.txt")).toEqual true
        expect(includesPath(result, "file1.txt")).toEqual true
        expect(includesPath(result, "file2.txt")).toEqual true
      
      it 'includes folders but not files', ->
        result = fsUtil.readDirSync path, files:false
        expect(includesPath(result, '.hidden')).toEqual true
        expect(includesPath(result, 'dir')).toEqual true
        expect(includesPath(result, ".hidden.txt")).toEqual false
        expect(includesPath(result, "file1.txt")).toEqual false
        expect(includesPath(result, "file2.txt")).toEqual false
      
      it 'includes neither folders or files (nothing)', ->
        result = fsUtil.readDirSync path, files:false, dirs:false
        expect(result.length).toEqual 0
      
      it 'does not include hidden items', ->
        result = fsUtil.readDirSync path, hidden:false
        expect(includesPath(result, '.hidden')).toEqual false
        expect(includesPath(result, ".hidden.txt")).toEqual false
      
        expect(includesPath(result, 'dir')).toEqual true
        expect(includesPath(result, "file1.txt")).toEqual true
        expect(includesPath(result, "file2.txt")).toEqual true

      describe 'deep read', ->
        it 'reads only the current level if deep but dirs:false', ->
          result = fsUtil.readDirSync path, dirs:false, deep:true
          expect(includesPath(result, '.hidden')).toEqual false
          expect(includesPath(result, 'dir')).toEqual false
          expect(includesPath(result, ".hidden.txt")).toEqual true
          expect(includesPath(result, "file1.txt")).toEqual true
          expect(includesPath(result, "file2.txt")).toEqual true
              
        it 'reads deep file path with hidden files', ->
          result = fsUtil.readDirSync path, deep:true
          
          expect(includesPath(result, '.hidden')).toEqual true
          expect(includesPath(result, '.hidden/file.txt')).toEqual true
          expect(includesPath(result, ".hidden.txt")).toEqual true
          expect(includesPath(result, 'dir')).toEqual true
          expect(includesPath(result, 'dir/file.txt')).toEqual true
          expect(includesPath(result, 'dir/child/grandchild1.txt')).toEqual true
          expect(includesPath(result, 'dir/child/grandchild2.txt')).toEqual true
          expect(includesPath(result, "file1.txt")).toEqual true
          expect(includesPath(result, "file2.txt")).toEqual true
                  
        it 'reads deep file path with folders only', ->
          result = fsUtil.readDirSync path, deep:true, files:false
          expect(includesPath(result, '.hidden')).toEqual true
          expect(includesPath(result, '.hidden/file.txt')).toEqual false
          expect(includesPath(result, ".hidden.txt")).toEqual false
          expect(includesPath(result, 'dir')).toEqual true
          expect(includesPath(result, 'dir/file.txt')).toEqual false
          expect(includesPath(result, 'dir/child/grandchild1.txt')).toEqual false
          expect(includesPath(result, 'dir/child/grandchild2.txt')).toEqual false
          expect(includesPath(result, "file1.txt")).toEqual false
          expect(includesPath(result, "file2.txt")).toEqual false
      

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


  describe 'exists', ->
    describe 'async', ->
      it 'aliases node Path version of the method', ->
        expect(fsUtil.exists).toEqual fsPath.exists
    
    describe 'synchronous', ->
      it 'determines that the path exists', ->
        path = "#{sampleDir}/empty"
        expect(fsUtil.existsSync(path)).toEqual true
        
      it 'determines that the path not exist', ->
        path = "#{sampleDir}/does_not_exist/foo.txt"
        expect(fsUtil.existsSync(path)).toEqual false

  
  describe 'createDir', ->
    dir = "#{sampleDir}/createDir/child1/child2"
    deleteSample = -> 
        tryTo -> fs.rmdirSync "#{sampleDir}/createDir/child1/child2"
        tryTo -> fs.rmdirSync "#{sampleDir}/createDir/child1"
        tryTo -> fs.rmdirSync "#{sampleDir}/createDir"
        
    beforeEach ->
        deleteSample()
      
    describe 'async', ->
      it 'creates a directory with multiple levels', ->
        result = null
        fsUtil.createDir dir, (err) -> result = true
        waitsFor -> result?
        runs -> 
          expect(fsUtil.existsSync(dir)).toEqual true
          deleteSample()
        
    describe 'synchronous', ->
      it 'creates a directory with multiple levels', ->
        result = fsUtil.createDirSync dir
        expect(result).toEqual true
        expect(fsUtil.existsSync(dir)).toEqual true
        deleteSample()

      it 'returns false when directly already exists', ->
        fsUtil.createDirSync dir
        result = fsUtil.createDirSync dir
        expect(result).toEqual false
        deleteSample()
    
      
  describe 'delete', ->
    dirRoot    = "#{sampleDir}/deleteDir"
    dirChild1  = "#{dirRoot}/child1"
    dirChild2  = "#{dirChild1}/child2"
    file1      = "#{dirRoot}/foo.txt"
    file2      = "#{dirChild2}/bar.txt"
    
    beforeEach ->
        fsUtil.writeFileSync file1, 'Delete Dir Content!'
        fsUtil.writeFileSync file2, 'Delete Dir Content!'

    describe 'synchronous', ->
      it 'force deletes the root', ->
        # NB: Force flag not specified because it is the default.
        fsUtil.deleteSync dirRoot        
        expect(fsUtil.existsSync(dirRoot)).toEqual false        
          
      it 'does not delete the root because it contains content', ->
        fsUtil.deleteSync dirRoot, force:false
        expect(fsUtil.existsSync(dirRoot)).toEqual true

      it 'deletes a file', ->
        fsUtil.deleteSync file2
        expect(fsUtil.existsSync(file2)).toEqual false        

      it 'does not fail when the folder to delete does not exist', ->
        fsUtil.deleteSync dirChild1
        fsUtil.deleteSync dirChild1

      it 'does not fail when the file to delete does not exist', ->
        fsUtil.deleteSync file2
        fsUtil.deleteSync file2
      
    describe 'async', ->
      it 'force deletes the root folder (including child content)', ->
        result = null
        # NB: Force flag not specified because it is the default.
        fsUtil.delete dirRoot, (err) -> result = true
        waitsFor -> result?
        runs ->
            expect(fsUtil.existsSync(dirRoot)).toEqual false

      it 'does not delete the root folder because it contains content', ->
        result = null
        # NB: Force flag not specified because it is the default.
        fsUtil.delete dirRoot, force:false, (err) -> result = true
        waitsFor -> result?
        runs ->
            expect(fsUtil.existsSync(dirRoot)).toEqual true
        
      it 'deletes a file', ->
        result = null
        # NB: Force flag not specified because it is the default.
        fsUtil.delete file2, (err) -> result = true
        waitsFor -> result?
        runs ->
            expect(fsUtil.existsSync(file2)).toEqual false

      it 'does not fail when the folder to delete does not exist', ->
        result = null
        error = undefined
        path = dirChild1
        fsUtil.delete path, (err) -> 
            error = err if err?
            fsUtil.delete path, (err) -> 
                error = err if err?
                result = true
        waitsFor -> result?
        runs -> 
          expect(error).not.toBeDefined()

      it 'does not fail when the file to delete does not exist', ->
        result = null
        error = undefined
        path = file2
        fsUtil.delete path, (err) -> 
            error = err if err?
            fsUtil.delete path, (err) -> 
                error = err if err?
                result = true
        waitsFor -> result?
        runs -> 
          expect(error).not.toBeDefined()


  describe 'copy', ->
    sourceDir   = "#{sampleDir}/copy/source"
    targetDir   = "#{sampleDir}/copy/target"
    folder1     = 'folder1'
    folder2     = 'folder1/folder2'
    file1       = 'file1.txt'
    file2       = 'folder1/file2.txt'
    file3       = 'folder1/file3.txt'
    file4       = 'folder1/folder2/file4.txt'
    file5       = 'folder1/folder2/file5.txt'
    folderEmpty = 'empty'
    img         = 'ants.png'
    
    files = [ file1, file2, file3, file4, file5 ]
    folders = [ folder1, folder2, folderEmpty ]
    allPaths = _.union(files, folders)
    
    sourcePath = (path) -> "#{sourceDir}/#{path}"
    targetPath = (path) -> "#{targetDir}/#{path}"
    targetExists = (path) -> fsUtil.existsSync(targetPath(path))
    
    setupSource = -> 
        write = (path, content) -> fsUtil.writeFileSync sourcePath(path), content
        write file1, 'Foo 1'
        write file2, 'Foo 2'
        write file3, 'Foo 3'
        write file4, 'Foo 4'
        write file5, 'Foo 5'
        fsUtil.createDirSync sourcePath(folderEmpty)
    
    resetTarget = -> 
        fsUtil.deleteSync targetDir
        fsUtil.createDirSync targetDir
    
    beforeEach ->
        setupSource()
        resetTarget()
    
    describe 'synchronous', ->
        it 'copies to a folder that already exists', ->
          source = sourcePath(file1)
          target = targetPath(file1)
          fsUtil.copySync source, target
          expect(fsUtil.existsSync(target)).toEqual true
          resetTarget()
        
        it 'copies an image', ->
          source = sourcePath(img)
          target = targetPath(img)
          fsUtil.copySync source, target

          imgSource = fs.readFileSync(source)
          imgTarget = fs.readFileSync(target)
          expect(imgSource).toEqual imgTarget
          resetTarget()
        
        it 'copies to a deep location', ->
          source = sourcePath(file4)
          target = targetPath(file4)
          fsUtil.copySync source, target
          expect(fsUtil.existsSync(target)).toEqual true
          resetTarget()
        
        it 'does not overwrite existing content', ->
          source = sourcePath(file4)
          target = targetPath(file4)
          fsUtil.copySync source, target
          
          fsUtil.writeFileSync sourcePath(file4), 'New content'
          fsUtil.copySync source, target
          
          expect(fs.readFileSync(target).toString()).toEqual 'Foo 4' # Not the new content.
          resetTarget()
          
        it 'does overwrite existing content', ->
          source = sourcePath(file4)
          target = targetPath(file4)
          fsUtil.copySync source, target
          
          fsUtil.writeFileSync sourcePath(file4), 'New content'
          fsUtil.copySync source, target, overwrite:true
          
          expect(fs.readFileSync(target).toString()).toEqual 'New content'
          resetTarget()
          
      describe 'folder copy', ->
        it 'copies to a deep location with content', ->
          source = sourcePath(folder2)
          target = targetPath(folder2)
          result = fsUtil.copySync source, target

          expect(targetExists(folder2)).toEqual true
          expect(targetExists(file4)).toEqual true
          expect(targetExists(file5)).toEqual true
          resetTarget()
          
        it 'copies a root folder with all child content', ->
          result = fsUtil.copySync sourceDir, targetDir, overwrite:true
          for path in allPaths
            expect(targetExists(path)).toEqual true
          resetTarget()
                
    
    describe 'async', ->
      describe 'file copy', ->
        it 'copies to a deep location', ->
          result = null
          source = sourcePath(file4)
          target = targetPath(file4)
          fsUtil.copy source, target, (err) -> result = true
          waitsFor -> result?
          runs ->
              expect(targetExists(file4)).toEqual true
              resetTarget()
        
        it 'does not overwrite existing content', ->
          result = null
          source = sourcePath(file4)
          target = targetPath(file4)
          fsUtil.copy source, target, (err) -> 
              fsUtil.writeFileSync sourcePath(file4), 'New content'
              fsUtil.copy source, target, (err) -> result = true
          waitsFor -> result?
          runs ->
              expect(fs.readFileSync(target).toString()).toEqual 'Foo 4' # Not the new content.
              resetTarget()

        it 'does overwrite existing content', ->
          result = null
          source = sourcePath(file4)
          target = targetPath(file4)
          fsUtil.copy source, target, (err) -> 
              fsUtil.writeFileSync sourcePath(file4), 'New content'
              fsUtil.copy source, target, overwrite:true, (err) -> result = true
          waitsFor -> result?
          runs ->
              expect(fs.readFileSync(target).toString()).toEqual 'New content'
              resetTarget()

      describe 'folder copy', ->
        it 'copies to a deep location with content', ->
          result = null
          source = sourcePath(folder2)
          target = targetPath(folder2)
          fsUtil.copy source, target, (err) -> result = true
          waitsFor -> result?
          runs ->
              expect(targetExists(folder2)).toEqual true
              expect(targetExists(file4)).toEqual true
              expect(targetExists(file5)).toEqual true
              resetTarget()

        it 'copies a root folder with all child content', ->
          result = null
          fsUtil.copy sourceDir, targetDir, overwrite:true, (err) -> result = true
          waitsFor -> result?
          runs ->
              for path in allPaths
                expect(targetExists(path)).toEqual true
              resetTarget()
          
        

  describe 'writeFile', ->
    dir = null
    file1 = null
    file2 = null
    deleteSample = -> 
        tryTo -> fs.unlinkSync file1
        tryTo -> fs.unlinkSync file2
        tryTo -> fs.rmdirSync dir
  
    beforeEach ->
        dir  = "#{sampleDir}/writeFile/folder"
        file1 = "#{dir}/file1.txt"
        file2 = "#{dir}/file2.txt"
        deleteSample()
      
    
    describe 'synchronous', ->
      it 'write a single file creating the containing directory', ->
        fsUtil.writeFileSync file1, 'Sync!'
        data = fs.readFileSync(file1)
        expect(data.toString()).toEqual 'Sync!'
        deleteSample()

      it 'overwrite a file', ->
        fsUtil.writeFileSync file1, 'Hello!'
        fsUtil.writeFileSync file1, 'New!'
        data = fs.readFileSync(file1)
        expect(data.toString()).toEqual 'New!'
        deleteSample()

      it 'writes multiple files creating the containing directory', ->
        files = [
            { path:file1, data:'Sync1' }
            { path:file2, data:'Sync2' }
          ]
        fsUtil.writeFilesSync files
        expect(fs.readFileSync(file1).toString()).toEqual 'Sync1'
        expect(fs.readFileSync(file2).toString()).toEqual 'Sync2'
      
    
    describe 'async', ->
      it 'write a single file creating the containing directory', ->
        result = null
        fsUtil.writeFile file1, 'Hello!', (err) -> result = true
        waitsFor -> result?
        runs ->
            data = fs.readFileSync(file1)
            expect(data.toString()).toEqual 'Hello!'
            deleteSample()

      it 'write a multiple files creating the containing directory', ->
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
      
    
  
  
  
  
  
  
  
  
  
  