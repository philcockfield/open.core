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
      html = markdown.parse source
      
      
      
