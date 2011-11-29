https = require 'https'


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
      syncAndSave = (user) -> 
        save = false
        for key in ['name', 'avatar']
          if user[key] isnt data[key]
            save = true
            user[key] = data[key]
        
        # Save the user and complete the promise.
        if save
          user.save (err) -> 
            if err?
              promise.fail err
            else
              promise.fulfill user
        else
          promise.fulfill user
      
      # Look up the user.
      User.findByProvider id:id, type:data.type, (err, user) -> 
        if err?
          promise.fail err
        else if user?
          syncAndSave user
        else
          # Create the new user.
          user = new User()
          user.addProvider type:data.type, id:id
          syncAndSave user
      
      # Finish up.
      promise



    