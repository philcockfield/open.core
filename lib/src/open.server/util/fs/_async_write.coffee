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

      # 1. Ensure the directory exists.
      dir = fsPath.dirname(path)
      @createDir dir, (err) ->
          if err?
              callback?(err)
              return # Failed - exit out.
          else
              # 2. Write the file.
              fs.writeFile path, data, encoding, callback


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
       failed = false
       loaded = 0

       onWritten = ->
          return if failed
          loaded += 1
          callback?() if loaded == files.length

       for file in files
          @writeFile file.path, file.data, (err) ->
            if err?
                failed = true
                callback?(err)
                return # Failed.
            else
              onWritten()
  