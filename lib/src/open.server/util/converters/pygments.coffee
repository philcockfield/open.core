{exec} = require 'child_process'
uuid   = require 'node-uuid'
core   = require 'open.server'
http   = require 'http'


###
A wrapper for the Pygments source-code highlighting library.

See: http://pygments.org/
Requires Pygments to be installed.

###
module.exports = 
  ###
  Converts the 'source' code to highlighted HTML.
  @param options: 
            - source:       The source code to highlight.
            - language:     The language of the source code 
                            (this is the file extension for the kind file the language is
                            is saved in, for example: '.coffee' for CoffeeScript).
            - useService:   Flag indicating if a pygments remote service should be used (rather than the 
                            local library) to perform.  Useful for situations where the pygments library
                            is not installed, ie. on a Heroku node instance.  Default:false
  @param callback(err, html) : Invoked when the highlight is complete.  Passes back the resulting HTML.
  ###
  toHtml: (options = {}, callback) ->       
      
      # Setup initial conditions.
      fsUtil     = core.util.fs
      onExec     = core.util.onExec
      
      source     = options.source
      useService = options.useService ? false
      language   = options.language ? 'coffee'
      language   = _(language).ltrim('.')
      file       = "#{core.paths.root}/_tmp/#{uuid()}.#{language}"
      
      # Exit out if no source code was provided.
      unless source?
        callback? new Error 'No source code provided'
        return
      
      fromCommandLine = -> 
        # Functions.
        saveSource   = (onComplete) => fsUtil.writeFile file, source, onComplete
        deleteSource = (onComplete) -> fsUtil.delete file, onComplete
        highlight = (onComplete) -> 
            cmd = "pygmentize -f html #{file}"
            exec cmd, (err, stdout, stderr) -> onComplete err, stdout
        
        # Execute sequence.
        saveSource -> 
          highlight (err, html) -> 
            deleteSource -> 
                callback? err, html
      
      fromCommandLine()
      

# PRIVATE --------------------------------------------------------------------------



  