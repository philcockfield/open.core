
  ###
  Manages vendoring a Git repo for deployment to Heroku (etc) that 
  contains specific private [node_modules] that cannot be pulled
  publicly by NPM.

  Process:
  
    - Delete existing target folder.
    - Copy repo to new target folder.
    - Initialze as .git repo
    - Update .gitignore removing 'node_modules_private' (so that it commits to the deploy repo)
    - Add all and commit.
    - Add remote (which will be a "deployment" branch on GitHub).
      This will cause the CI server to pull (from this "complete" deployment branch, 
      which in turn will deploy to heroku if successful)
  
  ###
  module.exports = 
  
  
  