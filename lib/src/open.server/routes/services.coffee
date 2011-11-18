core    = require 'open.server'
app     = core.app
paths   = core.paths
send    = core.util.send

console.log 'foo'


# POST: Pygments (source-code highlighting).
app.post "#{core.baseUrl}/pygments", (req, res) ->
    pygments = new core.util.Pygments
        language: req.body.language
        source:   req.body.source
    pygments.toHtml (err, html) -> 
        if err?
          res.send err.message, 500
        else
          res.send html
