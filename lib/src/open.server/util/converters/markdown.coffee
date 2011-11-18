markdown = require 'markdown'

###
A wrapper for the Markdown conversion library.

See: https://github.com/evilstreak/markdown-js

###
module.exports = class Markdown
  ###
  Constructor.
  @param options
  ###
  constructor: (options = {}) -> 
  
  
  ###
  Converts markdown to HTML.
  @param source:  The source markdown to convert.
  @param options: (optional)
  ###
  toHtml: (source, options = {}) ->       
      
      # Convert the markdown into HTML.
      html = markdown.parse source
      # html = toJQuery(html)
      
      # Finish up.
      """
      <div class="core_markdown">
        #{html}
      </div>
      """


# PRIVATE --------------------------------------------------------------------------


toJQuery = (html) -> 
    lines = html.split '\n'
    html = ''
    for line in lines
        html += line unless _.isBlank(line)
    $("<body>#{html}</body>")

