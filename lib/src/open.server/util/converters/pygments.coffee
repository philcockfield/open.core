{exec} = require 'child_process'
uuid   = require 'node-uuid'
core   = require 'open.server'


###
A wrapper for the Pygments source-code highlighting library.

See: http://pygments.org/
Requires Pygments to be installed.

###
module.exports = 
  ###
  Converts the 'source' code to highlighted HTML.
  @param options: 
            - source:   The source code to highlight.
            - language: The language of the source code 
                        (this is the file extension for the kind file the language is
                         is saved in, for example: '.coffee' for CoffeeScript).
            - fullPage:  Flag indicating a full page should be generated (true), or just a partial
                         snippet of HTML (false).  Default false.
  @param callback(err, html) : Invoked when the highlight is complete.  Passes back the resulting HTML.
  ###
  toHtml: (options = {}, callback) ->       
      
      # Setup initial conditions.
      fsUtil  = core.util.fs
      onExec  = core.util.onExec
      
      source    = options.source
      fullPage  = options.fullPage
      language  = options.language ? 'coffee'
      language  = _(language).ltrim('.')
      file      = "#{core.paths.root}/_tmp/#{uuid()}.#{language}"
      
      # Exit out if no source code was provided.
      unless source?
        callback? new Error 'No source code provided'
        return
      
      # Functions.
      saveSource   = (onComplete) => fsUtil.writeFile file, source, onComplete
      deleteSource = (onComplete) -> fsUtil.delete file, onComplete
      highlight = (onComplete) -> 
          fullOption = if fullPage is yes then ' -O full ' else ''
          cmd        = "pygmentize -f html#{fullOption} #{file}"
          exec cmd, (err, stdout, stderr) -> onComplete err, stdout
      
      # Execute sequence.
      saveSource -> 
        highlight (err, html) -> 
          deleteSource -> 
              callback? err, html




  