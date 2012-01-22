libs =
    $:          require 'jquery'
    _:          require 'underscore'
    Backbone:   require 'backbone'

# Store in global namespace.
global._        = libs._
global.Backbone = libs.Backbone
global.$        = libs.$

# Extend underscore.
_.mixin require('underscore.string')
_.mixin uniqueUrl: (src, makeUnique = true) ->
              # Used to prevent caching.
              if makeUnique
                unique = "?uid_#{new Date().getTime()}" if makeUnique
                unique ?= ''
              src + unique
