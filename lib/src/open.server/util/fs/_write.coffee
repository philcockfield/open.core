fs      = require 'fs'
fsPath  = require 'path'

module.exports = 
  ###
  Writes the data to the specified path (creating the containing folder if required).
  @param path: of the file to write to.
  @param data: to write
  @param options (optional):
              - encoding: defaults to 'utf8'
  @param callback: (err)
  ###
  writeFile: (path, data, options..., callback) ->
      # Setup initial conditions.
      options = options[0] ?= {}
      encoding = options.encoding ?= 'utf8'
      dir = fsPath.dirname(path)

      # 1. Ensure the directory exists.
      @createDir dir, (err) ->
          if err?
              callback?(err)
              return # Failed - exit out.
          else
              # 2. Write the file.
              fs.writeFile path, data, encoding, callback


  ###
  Writes the data to the specified path (creating the containing folder if required).
  @param path: of the file to write to.
  @param data: to write
  @param options (optional):
              - encoding: defaults to 'utf8'
  ###
  writeFileSync: (path, data, options = {}) ->
      # Setup initial conditions.
      encoding = options.encoding ?= 'utf8'
      dir = fsPath.dirname(path)
      
      # 1. Ensure the directory exists.
      @createDirSync dir

      # 2. Write the file.
      fs.writeFileSync path, data, encoding
      
      



  ###
  Writes the collection of file to disk providing a single
  callback when complete.
  @param files: An array of files definitions taking the following form:
                [
                  {
                    path:     '/path/to/write/to',
                    data:     {the data to write},
                  }
                ]
  @param options (optional) - See 'writeFile' method
  @param callback: (err)
  ###
  writeFiles: (files, options..., callback) ->
     self = @
     options = options[0] ?= {}
     failed = false
     loaded = 0

     onWritten = ->
        return if failed
        loaded += 1
        callback?() if loaded == files.length

     for file in files
        @writeFile file.path, file.data, options, (err) ->
          if err?
              failed = true
              callback?(err)
              return # Failed.
          else
            onWritten()


  ###
  Writes the collection of file to disk providing a single
  callback when complete.
  @param files: An array of files definitions taking the following form:
                [
                  {
                    path:     '/path/to/write/to',
                    data:     {the data to write},
                  }
                ]
  @param options (optional) - See 'writeFile' method
  ###
  writeFilesSync: (files, options = {}) -> 
      @writeFileSync(file.path, file.data, options) for file in files





  