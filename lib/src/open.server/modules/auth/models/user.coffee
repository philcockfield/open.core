###
Represents a single person.
###
module.exports = (module) ->
  AuthProvider = module.model 'auth_provider'
  
  User = new module.Schema
    name:       String                # The first/last name of the user.
    email:      String                # The email address of the user.
    avatar:     String                # Url to the profile picture of the user.
    providers:  [AuthProvider.Schema] # Collection of providers
  
  
  ###
  Adds a new authentication provider.
  @param options
          - id :  The user's id with the provider.
          - type: The unique identifier of the provider (eg. facebook, twitter etc).
  ###
  User.methods.addProvider = (options = {}) -> 
    
    # Setup initial conditions.
    throw 'Providers need an [id] and a [type]' unless options.id? and options.type?
    
    # Ensure the provider does not already exist.
    # TODO 
    
    # Insert the provider.
    @providers.push
      id:   options.id
      type: options.type
    
    # Finish up.
    @
  
  
  ###
  Adds a new authentication provider.
  @param options
          - id :  The user's id with the provider.
          - type: The unique identifier of the provider (eg. facebook, twitter etc).
  @param callback(err, user): Invoked upon completion.
  ###
  User.statics.findByProvider = (options = {}, callback) -> 
    
    # Setup initial conditions.
    unless options.id? and options.type?
      throw 'Need both an [id] and a provider [type] (eg. twitter)' 
    
    # Return the query.
    @findOne 'providers.id': options.id, 'providers.type': options.type, callback
  
  
  # Export.
  Model = module.mongoose.model 'User', User
  Model.Schema = User
  Model







  