core    = require 'open.server'
app     = core.app
send    = core.util.send


# POST: Pygments (source-code highlighting).
app.post "#{core.baseUrl}/pygments", (req, res) ->
    body = req.body
    core.util.pygments.toHtml 
      code:     body.code
      language: body.language,
      (err, html) -> 
        if err?
          res.send err.message, 500
        else
          res.send html


# POST: Markdown.
app.post "#{core.baseUrl}/markdown", (req, res) -> 
    markdown = req.body.markdown
    core.util.markdown.toHtml markdown, (err, html) -> 
      if err?
        res.send err.message, 500
      else
        res.send html



