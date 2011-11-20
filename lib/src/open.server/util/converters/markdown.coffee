markdown = (require 'markdown').markdown
Pygments = require './pygments'

###
A wrapper for the Markdown conversion library.

See: https://github.com/evilstreak/markdown-js

###
module.exports =
  ###
  Converts markdown to HTML.
  @param source:   The source markdown to convert.
  @param options:  
  @param callback: Invoked upon completion.
  ###
  toHtml: (source, options..., callback) ->
      
      # Setup initial conditions.
      options = options[0] ? {}
      
      # Parse the markdown into the HTML tree.
      htmlTree = markdown.toHTMLTree source
      
      # Walk the tree to provide extra formatting options.
      walk = (node) ->
        return unless _(node).isArray()
        formatElement node, @options
        for part in _(node).rest 1
          walk part if _.isArray part # <== Recursion: Process child node.
      walk htmlTree
      
      # Convert the tree into the final HTML.
      html = markdown.toHTML htmlTree
      """
      <div class="core_markdown">
        #{html}
      </div>
      """

    ###
    TODO
    - links | internal, external
    - syntax highlight code - ```coffee
    - Ensure char-returns aren't lost on PRE blocks.
    - Emdash conversion
    ###


# PRIVATE --------------------------------------------------------------------------


formatElement = (node, options) -> 
  switch node[0]
    when 'a'
      attr = node[1]
      if isExternal attr.href
        attr.target = '_blank'
        attr.class = 'core_external'
    else 
      # Ignore - no special formatting required.




isExternal = (href) -> 
    return false unless href?
    href = _(href)
    for prefix in ['http://', 'https://', 'mailto:']
      return true if href.startsWith(prefix)
    false



