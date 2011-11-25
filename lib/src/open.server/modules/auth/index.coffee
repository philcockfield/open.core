everyauth = require 'everyauth'
core      = require 'open.server'
mvc       = core.mvc


###
Server side authentication and authorization module.
###
module.exports = class AuthModule extends mvc.Module
  constructor: -> 
    super module
  
  
  ###
  Initializes the modules.
  @param options
          - app:      The Express app.
          - mongoose: The Mongoose library.
          - keys:     The authentication keys, takes the form of:
                      {
                        'provider-name': {
                            key:'application-key',
                            secret:'application-secret' 
                        }
                      }
                      Keys required for:
                        - Twitter
                        - Facebook
                        - LinkedIn
                        - Google
                        - Yahoo
          - paths:    Optional. The paths to configure everyauth with.
                        - redirectPath: default '/'
      
  @returns the module.
  ###
  init: (options = {}) -> 
    
    # Setup initial conditions.
    @mongoose  = options.mongoose ? require 'mongoose'
    @Schema    = @mongoose.Schema
    @everyauth = everyauth
    @paths     = paths = options.paths ? {}
    super options
    
    # Set default paths.
    paths.redirectPath ?= '/'
    
    # Start the Everyauth controller.
    new @controllers.Everyauth(options.keys)

    # Configure middleware.
    app = options.app
    if app
      app.use @everyauth.middleware()
      @everyauth.helpExpress app
    
    # Finish up.
    @
  

