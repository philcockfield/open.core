core     = require 'open.server'
markdown = (require 'markdown').markdown
pygments = require './pygments'

###
A wrapper for the Markdown conversion library.

See: https://github.com/evilstreak/markdown-js
###
module.exports =
  ###
  Converts markdown to HTML.
  @param options: 
            - source: The source markdown to convert.
  @param callback(err, html) : Invoked when the highlight is complete.  Passes back the resulting HTML.
  ###
  toHtml: (options = {}, callback) ->
    # Setup initial conditions.
    throw 'No source markdown supplied.' unless options.source?
    html    = markdown.toHTML options.source
    html    = toJQuery html
    
    # Format <a> tags.
    core.util.formatLinks html
    
    # Highlight source code.
    highlightCode html, (err, result) -> 
      
      if err?
        callback? err
        return

      # Convert back to HTML.
      html = result.html()
      html = html.replace /--/g, '&mdash;'
      html = """
              <div class="core_markdown">
                #{html}
              </div>
             """
      # Finish up.
      callback? null, html
      

    ###
    TODO
    - links | internal, external
    - syntax highlight code - ```coffee
    ###


# PRIVATE --------------------------------------------------------------------------


highlightCode = (html, callback) -> 
  count = 0
  onComplete = (err) -> 
    count -= 1
    if err?
      callback err
      callback = null # Prevent any more callbacks.
    else
      callback err, html if count is 0
  
  # Retrieve the collection of <code> blocks
  blocks = html.find 'pre > code'
  count  = blocks.length
  if count is 0
    onComplete()
    return
  
  # Enumerate each <code> block looking for
  # ones that require color-coding.
  for code in blocks
    code     = $ code
    language = matchFilter(code.html())
    
    if language?
      do (code) -> 
        
        # Remove the language filter prefix.
        source = code.html()
        source = source.substr language.length + 1, source.length
        source = core.util.unescapeHtml(source)
        
        # Syntax highlight the code in the specified language.
        language = mapLanguage language
        pygments.toHtml 
          source:   source
          language: language,
          (err, htmlCode) -> 
            unless err?
              # Replace the parent <pre> with the code color-coded HTML.
              pre = code.parent()
              pre.replaceWith htmlCode
            
            onComplete() # NB: Swallow error - leave code unchanged
          
    else
      # No instruction for color coding.
      onComplete()


matchFilter = (str) -> 
  match = str.match /^:.+\n/g
  return null unless match?
  match = match[0]
  match = _(match).chain().ltrim(':').rtrim('\n').value()


mapLanguage = (language) -> 
  switch language
    when 'ruby'   then 'rb'
    when 'c#'     then 'cs'
    when 'python' then 'py'
    else language


toJQuery = (html) -> 
    lines = html.split '\n'
    html = ''
    for line in lines
        html += line + '\n' unless _.isBlank(line)
    $("<body>#{html}</body>")


