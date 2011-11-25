module.exports = (module) ->
  Promise = module.everyauth.Promise
  User    = module.models.User
  util    =
    ###
    Finds or creates a user.
    @param data:
            - id   (provider)
            - type (provider)
            - name
            - avatar
    @returns a promise.
    ###
    findOrCreateUser: (data) -> 
      # Setup initial conditions.
      promise = new Promise()
      id      = data.id
  
      # Make sure details are up to date on the model.
      syncAndSave = (user, callback) -> 
    
        # TODO Look at "update" symatics.
        #      There could be a shorter way to write "syncing" code.
    
        save = false
        for key in ['name', 'avatar']
          if user[key] isnt data[key]
            save = true
            user[key] = data[key]
        if save
          user.save (err) -> callback err, user
        else
          callback null, user
  
      # Look up the user.
      # TODO Take both ID and type
      User.findByProvider id:id, type:data.type, (err, user) -> 
        if err?
          promise.fail err
          return
    
        if user?
          # User exists - return it now.
      
          # TODO CACHE HERE
          #  syncAndSave
      
          promise.fulfill user
      
        else
          # Create and save the new user.
          user = new User()
          user.addProvider type:data.type, id:id
          syncAndSave user, (err, user) -> 
            if err?
              promise.fail err
            else
              promise.fulfill user
    
      # Finish up.
      promise