###
Helper for simple client-side templates using the Underscore template engine.
###
module.exports = class Template
  constructor: ->

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