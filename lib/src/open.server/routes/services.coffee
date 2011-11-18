core    = require 'open.server'
app     = core.app
paths   = core.paths
send    = core.util.send


# POST: Pygments (source-code highlighting).
app.post "#{core.baseUrl}/pygments", (req, res) ->
    converter = new core.util.Pygments
        source:   req.body.source
        language: req.body.language
    converter.toHtml (err, html) -> 
        if err?
          res.send err.message, 500
        else
          res.send html


# POST: Markdown.
app.post "#{core.baseUrl}/markdown", (req, res) -> 
    converter = new core.util.Markdown()
    try
      html = converter.toHtml( req.body.source )
      res.send html
    catch error
      res.send error.message, 500
      
