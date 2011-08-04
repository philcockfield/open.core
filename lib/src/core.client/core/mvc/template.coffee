###
Helper for simple client-side templates using the Underscore template engine.
###
class Template
  constructor: ->

      # Replace members with template wrappers.
      exclude = ['constructor']
      for key of @
        unless (_(exclude).any (item)-> item == key) # Ignore excluded members.
          value = @[key]
          @[key] = new _.template(value) if _(value).isString()


# Export
module.exports = Template