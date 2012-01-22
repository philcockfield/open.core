{exec} = require 'child_process'
uuid   = require 'node-uuid'
core   = require '../../../server'
rest   = require 'restler'


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
      
      # Functions.
      saveSource   = (onComplete) => fsUtil.writeFile file, source, onComplete
      deleteSource = (onComplete) -> fsUtil.delete file, onComplete
      
      highlightService = (onComplete) -> 
        # Use the service if the local version of pygments is not installed.
        url  = 'http://pygmentize.herokuapp.com'
        post = rest.post url,
          data:
            code: source
            lang: toLanguage(language)
        
        post.on 'complete', (data, res) -> 
          onComplete(null, data) if res.statusCode is 200
        
        post.on 'error', (err) -> onComplete err, null
      
      highlight = (onComplete) -> 
        cmd = "pygmentize -f html #{file}"
        exec cmd, (err, stdout, stderr) -> 
          if err?
            # Failed locally, attempt conversion via web-service.
            highlightService onComplete
          else 
            onComplete err, stdout
      
      # Execute sequence.
      saveSource -> 
        highlight (err, html) -> 
          deleteSource -> 
              callback? err, html


# PRIVATE --------------------------------------------------------------------------


toLanguage = (fileExtension) -> 
  switch fileExtension
    when 'coffee' then 'coffeescript'
    else fileExtension





