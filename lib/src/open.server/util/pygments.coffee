{exec} = require 'child_process'
uuid   = require 'node-uuid'
core   = require 'open.server'


###
A wrapper for the Pygments source-code highlighting library.

See: http://pygments.org/
Requires Pygments to be installed.

###
module.exports = class Pygments
  
  ###
  Constructor.
  @param options
    - source:   The source code.
    - language: The language of the source code 
                (this is the file extension for the kind file the language is
                 is saved in, for example: '.coffee' for CoffeeScript).
  ###
  constructor: (options = {}) -> 
      
      # Setup initial conditions.
      @source   = options.source
      @language = options.language ? 'coffee'
      @language = _(@language).ltrim('.')
      throw 'No source code provided' unless @source?
  
  ###
  Converts the 'source' code to highlighted HTML.
  @param options: (optional)
            - fullPage:  Flag indicating a full page should be generated (true), or just a partial
                         snippet of HTML (false).  Default false.
  @param callback(err, html) : Invoked when the highlight is complete.  Passes back the resulting HTML.
  ###
  toHtml: (options..., callback) ->       
      
      # Setup initial conditions.
      fsUtil  = core.util.fs
      onExec  = core.util.onExec
      file    = "#{core.paths.root}/_tmp/#{uuid()}.#{@language}"
      
      # Setup default options.
      options = options[0] ? {}
      options.fullPage ?= false
      
      # Functions.
      saveSource   = (onComplete) => fsUtil.writeFile file, @source, onComplete
      deleteSource = (onComplete) -> fsUtil.delete file, onComplete
      highlight = (onComplete) -> 
          fullOption = if options.fullPage is yes then ' -O full ' else ''
          cmd = "pygmentize -f html#{fullOption} #{file}"
          exec cmd, (err, stdout, stderr) -> onComplete err, stdout
      
      # Execute sequence.
      saveSource -> 
        highlight (err, html) -> 
          deleteSource -> 
              callback? err, html




  