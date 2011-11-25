module.exports = (module) ->
  everyauth = module.everyauth
  
  class EveryauthController
    constructor: (keys) -> 
      
      # Setup initial conditions.
      throw new Error('Authentication provider keys required.') unless keys?
      User         = module.models.User
      findOrCreate = module.util.findOrCreateUser
      
      # Paths.
      paths = module.paths
      redirectTo = paths.redirectPath
      
      # Look up user based on Model id.
      # Used by [everyauth] internally to provider the 'user'
      # helper property on [req] and [everyauth] etc.
      everyauth.everymodule.findUserById (id, callback) -> User.findById id, callback
      
      
      # Configure authentication providers.
      do -> 
        
        # Twitter.
        everyauth.twitter
          .consumerKey(keys.twitter.key)
          .consumerSecret(keys.twitter.secret)
          .findOrCreateUser((session, accessToken, accessTokenSecret, userData) -> 
              findOrCreate
                type:   'twitter'
                id:     userData.id
                name:   userData.name
                avatar: userData.profile_image_url
          )
          .redirectPath redirectTo
        
        
        # Facebook.
        everyauth.facebook
          .appId(keys.facebook.key)
          .appSecret(keys.facebook.secret)
          .handleAuthCallbackError((req, res) -> 
            # Invoked if user denies access.
          )
          .findOrCreateUser((session, accessToken, accessTokenSecret, userData) -> 
              findOrCreate
                type:   'facebook'
                id:     userData.id
                name:   userData.name
          )
          .redirectPath redirectTo
        
        
        # LinkedIn.
        everyauth.linkedin
          .consumerKey(keys.linkedIn.key)
          .consumerSecret(keys.linkedIn.secret)
          .findOrCreateUser((session, accessToken, accessTokenSecret, userData) -> 
              findOrCreate
                type:   'linkedin'
                id:     userData.id
                name:   "#{userData.firstName} #{userData.lastName}"
                avatar: userData.pictureUrl
          )
          .redirectPath redirectTo




