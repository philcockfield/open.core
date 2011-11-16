core    = require 'open.server'
app     = core.app
paths   = core.paths
send    = core.util.send


# Dev (Home).
app.get "#{core.baseUrl}/dev", (req, res) ->
    
    # Ensure the path ends with a '/'
    unless _(req.url).endsWith '/'
          res.redirect req.route.path + '/'
          return
    
    core.util.render res, 'dev/index', 
                        layout:  false
                        pretty:  true
                        title:   'Open.Core (Dev)'
                        html:    core.util.html
                        baseUrl: core.baseUrl


# GET: Stylesheets.
app.get "#{core.baseUrl}/:stylesheet?.css", (req, res) ->
    stylesheet = req.params.stylesheet
    switch stylesheet
      when 'normalize', 'pygments' then path = 'libs'
      else path = 'core'
    send.cssFile res, "#{paths.stylesheets}/#{path}/#{stylesheet}.css"


# GET: Javascript file.
app.get "#{core.baseUrl}/:package?.js", (req, res) ->
    package = req.params.package
    min  = if minRequested(req) then '-min' else ''
    dir  = "#{paths.public}/javascripts"
    file = (name) -> 
            name = _.strLeftBack(name, '-min')
            "#{name}#{min}.js"
    libFile = (name) -> "#{dir}/libs/#{file(name)}"
    
    # Look for lib files.
    switch package
      when 'libs', 'libs-min' then file = libFile 'libs'
      when 'require', 'require-min' then file = libFile 'require'
      else
        # Not a lib file, return the core java-script.
        file = "#{dir}/core/#{file(package)}"

    send.scriptFile res, file


# POST: Pygments (source-code highlighting).
app.post "#{core.baseUrl}/pygments", (req, res) ->
    pygments = new core.util.Pygments
        language: req.body.language
        source:   req.body.source
    pygments.toHtml (err, html) -> 
        
        console.log 'err', err
        console.log 'html: \n', html
        
        res.send html
    
    
    


# Helpers --------------------------------------------------------------------------


minRequested = (req)-> _(req.params.package).endsWith '-min'


