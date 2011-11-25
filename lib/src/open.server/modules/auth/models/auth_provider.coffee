mongoose  = require 'mongoose'
Schema    = mongoose.Schema

###
Represents an authentication provider (such as Facebook or Twitter).
###
module.exports = (module) ->
  AuthProvider = new module.Schema
    id:   { type:String, index:true }
    type: { type:String, index:true }
  
  
  # AuthProvider.pre 'save', (next) -> 
  #   unless @id? and @type?
  #     error = new Error 'Must have both an [id] and a [type].'
  #   next error
  
  # Export.
  Model = module.mongoose.model 'AuthProvider', AuthProvider
  Model.Schema = AuthProvider
  Model

  