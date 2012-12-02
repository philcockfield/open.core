{exec}   = require 'child_process'
fs       = require 'fs'
fsUtil   = require '../fs'
JsonFile = require '../json_file'
common   = require '../common'
log      = common.log
Timer    = require '../timer'
git      = require '../git'


###
A wrapper around a node [package.private.json] file used for deploying
private module dependencies to hosting services like Heroku.
###
module.exports = class PrivatePackage extends JsonFile
  ###
  Constructor.
  @param path : The path or directory containing the [package.private.json] file.
  ###
  constructor: (path) -> 
    super path, 'package.private.json'
    @modulesDir   = "#{@dir}/node_modules.private"
    @dependencies = @data.dependencies ? []
  
  
  ###
  Deletes the [node_modules.private] directory.
  ###
  clear: -> 
    fsUtil.deleteSync @modulesDir, force:true
    createModulesDir @
  
  
  ###
  The path to the directory that NPM stores symbolic link references 
  to linked modules within.
  ###
  linkDir: "#{process.installPrefix}/lib/node_modules"
  
  
  ###
  Sets up symbolic links for each dependent module that has
  been installed locally within the [node_modules.private] folder.
  
  To make a module available for linking, from it's folder
  execute:
  
      npm link
      
  This will publish a symbolic link to it within the global
  modules folder.
  ###
  link: -> 
    # Setup initial conditions.
    if @dependencies.length > 0
      log 'Linking private packages:', color.blue
    else
      log 'No private packages to link', color.red
      return
    
    # Ensure the modules directory exists.
    createModulesDir @
    
    # Enumerate each dependnecy.
    for item in @dependencies
      log " ├─ #{item.name}", color.blue
      paths = dependencyPaths @, item
      
      # Ensure the source module exists.
      unless fsUtil.existsSync paths.source
        log '    ├─ Not found.  ', color.red, 'To link, run "npm link" in the dependency\'s folder.'
        continue
      
      # Delete the existing directory or link.
      deleteLink paths.target, force:true
      
      # Create the sumbolic link.
      fs.symlinkSync paths.source, paths.target
      log '    ├─ Linked from:', color.green, paths.source
      log '    ├─ Linked to:  ', color.green, paths.target
    
    # Finish up.
    log()
  
  
  ###
  Removes link within the [node_modules.private]
  ###
  unlink: -> 
    # Setup initial conditions.
    if @dependencies?.length > 0
      log 'Unlinking private packages:', color.blue
    else
      log 'No private packages to unlink', color.red
      return
    
    # Enumerate each dependnecy.
    for item in @dependencies
      log " ├─ #{item.name}", color.blue
      paths      = dependencyPaths @, item
      targetPath = paths.target
      
      # Ensure the source module exists.
      unless fsUtil.existsSync targetPath
        log '    ├─ Nothing to unlink.  ', color.red
        continue
      
      # Delete the link.
      if deleteLink(targetPath)
        log '    ├─ Removed link from:', color.green, targetPath
      else
        log '    ├─ Not removed (not a linked folder):', color.red, targetPath
    
    # Finish up.
    log()
  
  
  ###
  Clones dependencies that have remote repositories defined
  to the [node_modules.private] folder.
  
  @param callback(err): Invoked upon completion.
  
  ###
  update: (callback) -> 
    # Setup initial conditions.
    if @dependencies.length > 0
      log 'Updating private packages:', color.blue
    else
      log 'No private packages to update', color.red
      callback?()
      return
    
    # Ensure the modules directory exists.
    createModulesDir @
    
    cloningCount = 0
    count        = 0
    timer        = new Timer()
    onCloned = -> 
      count += 1
      return unless count is cloningCount
      log 'Update complete.', color.green, "#{cloningCount} repositores cloned in #{timer.secs()} seconds."
      log()
      callback?()
    
    # Enumerate each dependnecy.
    for item in @dependencies
      log " ├─ #{item.name}", color.blue
      repo = item.repository
      
      unless repo?
        log '    ├─ No repository defined.', color.red
        continue
      
      # Ensure the repository is supported.
      switch repo.type
        when 'git' then 
        else 
          log "    ├─ Repositories of type '#{repo.type}' are not supported.", color.red
          continue
      
      # Get the url.
      url = repo.url
      unless url?
          log "    ├─ No url provided for the #{repo.type} repository.", color.red
          continue
      
      # Check for existing directory.
      paths = dependencyPaths @, item
      if fsUtil.existsSync paths.target
        lstat = fs.lstatSync paths.target
        if lstat.isSymbolicLink()
          # It's been linked, ignore it.
          log "    ├─ Ignoring linked dependency:", color.blue, paths.target
          continue
        else
          # It's a cloned directory - delete it.
          fsUtil.deleteSync paths.target, force:true
          
      
      # Clone the repository.
      log "    ├─ Url: ", color.blue, url
      cloningCount += 1
      cmd = "git clone #{url} #{paths.target}"
      @_exec cmd, (err, stdout, stderr) ->
        if err?
          log "Failed: #{err.message}", color.red
          callback? err
          callback = null
          return
        else
          onCloned()  
    
    # Finish up.
    log()
    log.append ' Cloning now...', color.blue if cloningCount > 0
  
  
  ###
  Lists all the dependencies, printing their state to the console.
  ###
  ls: -> @list() # Alias the list method.
  list: -> 
    
    # Setup initial conditions.
    if @dependencies.length > 0
      log 'Private packages:', color.blue
    else
      log 'No private packages.', color.blue
      return
    
    # Enumerate each dependnecy.
    for item in @dependencies
      log " ├─ #{item.name}", color.blue
      paths = dependencyPaths @, item
      
      if fsUtil.existsSync paths.target
        lstat = fs.lstatSync paths.target
        if lstat.isSymbolicLink()
          log "    ├─ Linked", color.green
          log "       ├─ From:", color.green, paths.source
          log "       ├─ To:  ", color.green, paths.target
        else
          log "    ├─ Cloned", color.green
          log "       ├─ From:", color.green, item.repository.url
          log "       ├─ To:  ", color.green, paths.target
      else
        log "    ├─ Not found.", color.red
  
  
  ###
  Clones the repository to given path.
  @param path:  The path to the directory to clone to.
  @param options
              - force: Replaces an existing directory (default: true).
  @returns callback(err, package): Invoked upon completion.
              - err:     The error if one occured.
              - package: The [PrivatePackage] for the new clone.
  ###
  clone: (path, options..., callback) -> 
    
    # Setup initial conditions.
    throw new Error('No path specified') unless path?
    options = options[0] ? {}
    options.force ?= yes
    log 'Cloning to:', color.blue, path
    
    # Delete the directory if it already exists.
    if fsUtil.existsSync path
      if options.force is yes
        fsUtil.deleteSync path
      else
        
        throw new Error "Cannot clone. Directory already exists: #{path}"
        return
    
    # Copy the directory.
    fsUtil.copySync @dir, path, filter: (sourcePath) -> 
      exclude = [
        '/node_modules'
        '/node_modules.private'
        '.DS_Store'
      ]
      for item in exclude
        return false if _(sourcePath).endsWith item
      true
    
    # Create a private-package of the clone.
    path         = fs.realpathSync path
    packageClone = new PrivatePackage(path)

    
    # Update private packages.
    @update (err) => 
      if err?
        callback? err
        return
      
      # Remove the ignore statement for [node_modules.private]
      scrubGitIgnore @
      
      # Finish up.
      callback? null, packageClone
    
    
    ###
    Branches the package and prepares it for deployment.
     
     - Delete the {deploy} branch - [make the name and whether an error is thrown an option]
     - Checkout new branch: {deploy}
     - 
     - Delete 'node_modules'
     - Delete 'node_modules.private'
     - Remove .gitignore references to 'node_modules*'
     - Apply tag. (make an option)
     
     
     - Branch to: private_deploy
     - Tag
       - Remove the ignore statement for [node_modules.private]
       - Commit in all changes.
       - 
    
    @param options
        - initial:  The name of the initial branch to start on.
                    The current branch is used if nothing is specified.
        - branch:   The name of the branch (default: 'deploy')
        - tag:      The name of the tag to apply to the new branch.
    
    @param callback(err)
    ###
  branch: (options = {}, callback) -> 
    
    # Setup initial conditions.
    options.branch ?= 'deploy'
    
    # Branch.
    switchToInitial = (done) -> 
      if options.initial?
        git.exec "checkout #{options.initial}", done 
      else
        done()
    deleteBranch = (done) -> git.deleteBranch options.branch, done
    branch = (done) -> git.exec "checkout -b #{options.branch}", done
    
    switchToInitial -> deleteBranch -> branch -> 
    
    
    # Update the .gitignore file.
    scrubGitIgnore @
    
    # Update the private packages.
    @clear()
    @update (err) -> 
      
      callback? err
    
      
    
    
  
  
  # PRIVATE INSTANCE ----------------------------------------------------------------------
   
   
  _exec: (cmd, callback) -> exec cmd, callback


# PRIVATE STATIC --------------------------------------------------------------------------


createModulesDir = (pkg) -> fsUtil.createDirSync pkg.modulesDir


deleteLink = (path, options = {}) -> 
  return true unless fsUtil.existsSync path
  if fs.lstatSync(path).isSymbolicLink()
    fs.unlinkSync path
    return true
  else
    if options.force is yes
      fsUtil.deleteSync path, force:true
    else
      return false


dependencyPaths = (pkg, item) -> 
  paths =
    source: "#{pkg.linkDir}/#{item.name}"
    target: "#{pkg.modulesDir}/#{item.name}"


scrubGitIgnore = (pkg) -> 
  # Setup initial conditions.
  path = "#{pkg.dir}/.gitignore"
  
  # Read the file.
  gitignore = fs.readFileSync(path).toString()
  lines = _(gitignore).lines()
  
  console.log 'BEFORE\n', lines
  
  # Remove the private node modules ignore statement.
  for line, i in lines
    lines[i] = null if line is 'node_modules.private'
  lines = _(lines).compact()
  
  # Save the results back to the [.gitignore] file.
  data = ''
  for line in lines
    data += "#{line}\n"
  fsUtil.writeFileSync path, data
  
  
  
  



