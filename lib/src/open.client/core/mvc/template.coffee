###
Helper for simple client-side templates using the Underscore template engine.
###
module.exports = class Template
  
  ###
  Constructor.
  @param props: An object containing values to attach as properties to the template.
                
                As well as properties passed into the template property functions themselves
                templates can access properties on the [Template] object which can be
                passed into the constructor.
                
                For example, if the template was constructed like this:
                
                  tmpl = new MyTemplate( foo:123 )
                
                The 'foo' property would be accessed within the template like this
                
                  root:
                      """"
                      <div><%= tmpl.foo %></div>
                      """"
                
                Note: 'tmpl' is a reference to the template that is passed into all
                      template functions automatically.  It is just available.
                
                Any existing properties on the template are NOT overwritten by a 
                property contained within the 'props' argument.
  ###
  constructor: (props) -> Template::_construct.call @, props
  
  
  ###
  Called internally by the constructor.  
  Use this if properties are added to the object after
  construction and you need to re-run the constructor,
  (eg. within a functional inheritance pattern).
  ###
  _construct: (props = {}) -> 
      # Replace members with template wrappers.
      exclude = ['constructor']
      for key of @
        unless (_(exclude).any (item)-> item == key) # Ignore excluded members.
            value = @[key]
            @[key] = @toTemplate(value) if _(value).isString()
      
      # Copy property values passed to constructor.
      for name of props
          @[name] = props[name] unless @[name]?
  
  
  ###
  Converts a template string into a compiled template function.
  Override this to use a template library other than the default underscore engine.
  @param str: The HTML template string.
  ###
  # toTemplate: (str) -> _.template(str)
  toTemplate: (str) -> 
    self = @
    fn   = _.template(str)
    return (args = {}) -> 
        # Curried function.  Pass in a reference to the template itself.
        # NB: This allows other template functions to be accessed from 
        #     within the executing template
        #     It is more reliable than calling 'this' from within the template
        #     as the context of 'this' will change if within a _ 'each' loop
        #     for instance.
        args.tmpl ?= self
        fn(args)
    
    
      





  