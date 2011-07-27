require './config/libs'
paths           = require './config/paths'
configure       = require './config/configure'
configure.specs = require './routes/specs'

server =
  title:       'Open.Core (Server)'
  paths:       paths
  util:        require './util'
  client:      require 'core.client'
  configure:   configure

  ###
  Generates the standard copyright notice (MIT).
  @param options (optional)
          - asComment: Flag indicating if the copyright notice should be within an HTML comment.
  ###
  copyright: (options = {}) ->
      notice = "Copyright #{new Date().getFullYear()} Phil Cockfield. All rights reserved."
      if options.asComment
                notice = """
                /*
                  #{notice}
                  The MIT License (MIT)
                  https://github.com/philcockfield/open.core
                */
                """
      notice


# Export
module.exports = server
