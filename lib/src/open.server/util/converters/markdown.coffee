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
      
      
      
      # Finish up.
      """
      <div class="core_markdown">
        #{html}
      </div>
      """
      
      
      
