markdown = require 'markdown'

###
A wrapper for the Markdown conversion library.

See: https://github.com/evilstreak/markdown-js

###
module.exports = class Markdown
  ###
  Constructor.
  @param options
    - source:   The source markdown.
  ###
  constructor: (options = {}) -> 
      
      # Setup initial conditions.
      @source   = options.source
      throw 'No source code provided' unless @source?
  
  
  ###
  Converts the 'source' markdown to HTML.
  @param options: (optional)
  ###
  toHtml: (options = {}) ->       
      
      console.log 'markdown', markdown
      
      html = markdown.parse @source
      
      
      
