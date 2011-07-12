###
Helper for simple client-side templates using the Underscore template engine
in must Mustache mode.
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