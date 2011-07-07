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

