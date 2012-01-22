core     = require '../../../server'
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
            - source:     String. The source markdown to convert.
            - classes:    The CSS classes to assign to various elements
                - prefix:   The prefix to assign to default CSS class names (default: 'core_').
                - root:     The root CSS class (default: 'core_markdown').
                - code:     The <pre> CSS class for code blocks.
                            Options:
                              - {core_}inset  : Sunken border. (Default)
                              - {core_}simple : Simple left vertical line.
  @param callback(err, html) : Invoked when the highlight is complete.  Passes back the resulting HTML.
  ###
  toHtml: (options = {}, callback) ->
    # Setup initial conditions.
    throw 'No source markdown supplied.' unless options.source?
    html    = markdown.toHTML options.source
    html    = toJQuery html
    
    # Assign default CSS classes.
    prefix  = 'core_'
    classes = options.classes ?= {}
    classes.prefix      ?= prefix
    classes.root        ?= prefix + 'markdown'
    classes.highlight   ?= prefix + 'highlight'
    classes.code        ?= prefix + 'inset'
    
    # Format <a> tags.
    core.util.formatLinks html
    
    # Highlight source code.
    syntaxHighlight html, options, (err, result) -> 
      if err?
        callback? err
        return
      
      # Convert back to HTML.
      html = result.html()
      html = html.replace /--/g, '&mdash;'
      html = """
              <div class="#{classes.root}">
                #{html}
              </div>
             """
      
      # Finish up.
      callback? null, html


# PRIVATE --------------------------------------------------------------------------


syntaxHighlight = (html, options, callback) -> 
  count = 0
  onComplete = (err) -> 
    count -= 1
    if err?
      callback err
      callback = null # Prevent any more callbacks.
    else
      callback err, html if count <= 0
  
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
      do (code, language) -> 
        
        # Remove the language filter prefix.
        source = code.html()
        source = source.substr language.length + 2, source.length
        
        # Syntax highlight the code in the specified language.
        language = toFileExtension language
        pygments.toHtml 
          source:   core.util.unescapeHtml(source)
          language: language
          (err, htmlCode) -> 
            if err?
              # Failed. Replace <code> block with the source that
              # had the :language filter removed.
              code.html source
            else
              # Replace the parent <pre> with the code color-coded HTML.
              htmlCode = $ htmlCode
              pre = code.parent()
              pre.replaceWith htmlCode
              
              # Adorn with CSS classes.
              classes = options.classes
              htmlCode.addClass "#{classes.prefix}highlight"
              htmlCode.addClass "#{classes.prefix}language_#{language}"
              htmlCode.addClass classes.code
            
            onComplete() # NB: Swallow error - leave code unchanged
          
    else
      # No instruction for color coding.
      onComplete()


matchFilter = (str) -> 
  match = str.match /^:.+\n/g
  return null unless match?
  match = match[0]
  match = _(match).chain().ltrim(':').rtrim('\n').value()


toFileExtension = (language) -> 
  switch language
    when 'coffeescript', 'coffee-script' then 'coffee'
    when 'json', 'javascript'            then 'js'
    when 'ruby'   then 'rb'
    when 'c#'     then 'cs'
    when 'python' then 'py'
    else language


toJQuery = (html) -> 
    lines = html.split '\n'
    html = ''
    for line in lines
        html += line + '\n' 
    $("<body>#{html}</body>")


