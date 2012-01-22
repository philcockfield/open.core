core    = require '../'
app     = core.app
send    = core.util.send


# POST: Pygments (source-code highlighting).
app.post "#{core.baseUrl}/pygments", (req, res) ->
  body = req.body
  
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
  options =
    source:  req.body.source
    classes: req.body.classes
  core.util.markdown.toHtml options, (err, html) -> 
    if err?
      res.send err.message, 500
    else
      res.send html



