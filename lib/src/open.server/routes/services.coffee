core    = require 'open.server'
app     = core.app
send    = core.util.send


# POST: Pygments (source-code highlighting).
app.post "#{core.baseUrl}/pygments", (req, res) ->
  body = req.body
  
  console.log 'PY body', body # TEMP 
  
  core.util.pygments.toHtml 
    source:       body.source
    language:     body.language
    useService:   body.useService
    (err, html) -> 
      if err?
        res.send err.message, 500
      else
        res.send html


# POST: Markdown.
app.post "#{core.baseUrl}/markdown", (req, res) -> 
  source = req.body.source
  core.util.markdown.toHtml source:source, (err, html) -> 
    if err?
      res.send err.message, 500
    else
      res.send html



