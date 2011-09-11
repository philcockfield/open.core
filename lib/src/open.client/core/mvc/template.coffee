###
Helper for simple client-side templates using the Underscore template engine.
###
module.exports = class Template
  
  ###
  Constructor.
  @param props: An object containing values to attach as properties to the template.
                This allows these values to be accessed within a template.
                For example, if the template was constructed like this:
                
                  tmpl = new MyTemplate( foo:123 )
                
                The 'foo' property would be accessed within the template like this
                
                  root:
                      """"
                      <div><%= this.foo %></div>
                      """"
                
                Any existing properties on the template are NOT overwridden by a 
                property contained within the 'props' argument.
  ###
  constructor: (props = {}) ->
      
      # Copy property values.
      for name of props
          @[name] = props[name] unless @[name]?
      
      # Replace members with template wrappers.
      exclude = ['constructor']
      for key of @
        unless (_(exclude).any (item)-> item == key) # Ignore excluded members.
            value = @[key]
            @[key] = @toTemplate(value) if _(value).isString()


  ###
  Converts a template string into a compiled template function.
  Override this to use a template library other than the default underscore engine.
  @param tmpl: The HTML template string.
  ###
  toTemplate: (tmpl) -> new _.template(tmpl)