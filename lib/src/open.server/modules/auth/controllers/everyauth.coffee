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
        if keys.twitter?
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
        if keys.facebook?
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
        if keys.linkedin
          everyauth.linkedin
            .consumerKey(keys.linkedin.key)
            .consumerSecret(keys.linkedin.secret)
            .findOrCreateUser((session, accessToken, accessTokenSecret, userData) -> 
                findOrCreate
                  type:   'linkedin'
                  id:     userData.id
                  name:   "#{userData.firstName} #{userData.lastName}"
                  avatar: userData.pictureUrl
            )
            .redirectPath redirectTo
        
        
        everyauth.debug = true
        
        # Google (OAuth2).
        if keys.google?
          everyauth.google
            .appId(keys.google.key)
            .appSecret(keys.google.secret)
            .scope('https://www.googleapis.com/auth/userinfo.profile')
            .handleAuthCallbackError((req, res) -> 
              # Invoked if user denies access.
              
              # https://www.google.com/m8/feeds
              # https://www.googleapis.com/auth/userinfo.profile
              # https://www.googleapis.com/auth/plus.me
              
            )
            .findOrCreateUser((session, accessToken, accessTokenSecret, userData) -> 
                
                console.log 'accessToken', accessToken
                console.log 'accessTokenSecret', accessTokenSecret
                console.log ''
                
                # module.util.getGoogleProfile accessToken, (profile) -> 
                #   console.log 'userData', userData
                #   console.log 'profile', profile
                
                # console.log 'accessToken', accessToken
                # console.log 'accessTokenSecret', accessTokenSecret
                # console.log 'GOOGLE', userData
              
                # findOrCreate
                #   type:   'google'
                #   id:     userData.id
                #   name:   "#{userData.firstName} #{userData.lastName}"
                #   avatar: userData.pictureUrl
            )
            .redirectPath redirectTo
        
        
        # Yahoo (OAuth).
        if keys.yahoo?
          everyauth.yahoo
            .consumerKey(keys.yahoo.key)
            .consumerSecret(keys.yahoo.secret)
            .findOrCreateUser((session, accessToken, accessTokenSecret, userData) -> 
                
                console.log 'YAHOO: ', userData
                
                # findOrCreate
                #   type:   'yahoo'
                #   id:     userData.id
                #   name:   "#{userData.firstName} #{userData.lastName}"
                #   avatar: userData.pictureUrl
            )
            .redirectPath redirectTo





