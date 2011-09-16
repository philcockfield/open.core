{exec} = require 'child_process'
util   = require('./common')
log    = util.log
onExec = util.onExec

formatStrParam = (value, defaultValue) -> 
      value = _.trim(value) if value?
      value ?= defaultValue if defaultValue?
      value


module.exports =
  ###
  Executes the given git command.
  @param cmd      : Git command to execute.
  @param options
                  - dir     : (optional) The directory the git repository is in (default current).
                  - onExec  : (optional) Flag indicating whether the standard onExec handler 
                                         should be invoked (default true).
  @param callback(err, stdout, stderr)
  ###
  exec: (cmd, options..., callback) ->
      # Setup initial conditions.
      options = options[0] ?= {}
      dir = options.dir
      
      # Prepare the command to execute.
      if dir?
        cmd = "git --git-dir=#{dir}/.git --work-tree=#{dir} #{cmd}"
      else
        cmd = "git #{cmd}"
      
      # Execute the command.
      exec cmd, (err, stdout, stderr) ->
          onExec(err, stdout, stderr) if (options.onExec ?= true)
          callback?(err, stdout, stderr)

  ###
  Commits all items to the repository (adding them first using '.' and -u if add is required).
  @param message  : The commit message.
  @param options
                  - dir     : (optional) The directory the git repository is in (default current).
                  - add     : (optional) Whether to add everything before invoking the commit (default true).
  @param callback(err, stdout, stderr)
  ###
  commit: (message, options..., callback) -> 
      options = options[0] ?= {}
      dir = options.dir
      add = options.add ?= true
      msg = _.trim(message)
      throw 'A message (-m) must be provided for commits, eg. cake -m "MESSAGE" commit' unless msg? and msg.length > 0
      log 'Committing...', color.blue
      
      fnAdd = (onComplete) => 
          if not add
              # Add not required.
              onComplete()
              return
          @exec 'add .', dir:dir, (err, stdout, stderr) =>
            @exec 'add -u', dir:dir, (err, stdout, stderr) =>
              onComplete()
      
      fnCommit = () =>     
          @exec "commit -m \"#{msg}\"", dir:dir, onExec:false, (err, stdout, stderr) ->
            if err?.code == 1
              log 'Nothing to commit', color.red
            else
              onExec err, stdout, stderr
              log 'Commit done', color.green
            callback?(err, stdout, stderr)
          
      fnAdd -> fnCommit()
      

  ###
  Pushes a repository to the remote host.
  @param options
            - dir     : (optional) The directory the git repository is in (default current).
            - commit  : (optional) A commit message. If supplied the changes are commited prior to pushing.
            - branch  : (optional) The remove branch to push to.
            @param callback(err, stdout, stderr)
  ###
  push: (options..., callback) -> 
    
    # Setup initial conditions.
    options = options[0] ?= {}
    dir     = formatStrParam(options.dir)
    commit  = formatStrParam(options.commit)
    branch  = formatStrParam(options.branch, '')
    log "Pushing to remote host...", color.blue
    
    push = () =>
      @exec "push -u origin #{branch}", (err, stdout, stderr) ->
          onExec err, stdout, stderr
          log 'Pushing done', color.green
          callback?(err, stdout, stderr)
    
    # Check whether commit is required.
    if commit?
      @commit commit, add:true, => push()
    else
      push()
  
  
  ###
  Peforms a pull by executing a 'fetch' then 'merge' operation.
  Note: 'Fetch then Merge' is required, as opposed to a simple 'pull' because there is
        currently a bug in Git where pull will not work when the working-directory
        is changed.
  @param options
            - dir     : (optional) The directory the git repository is in (default current).
            - branch  : (optional) The branch to merge.  The default is 'master'
            - remote  : (optional) The name of the remote to pull from.  The default is 'origin'
  @param callback(err, stdout, stderr)
  ###
  pull: (options..., callback) ->

      # Setup initial conditions.
      options = options[0] ?= {}
      dir        = formatStrParam(options.dir)
      branch     = formatStrParam(options.branch, 'master') 
      remote     = formatStrParam(options.remote, 'origin')

      log "+ Pulling '#{branch}'... [fetch -> merge]", color.blue
      @exec 'fetch', dir:dir, => 
             @exec "merge #{remote}/#{branch}", dir:dir, (err, stdout, stderr) => 
                 log "- Done pulling '#{branch}'", color.green
                 callback?(err, stdout, stderr)
      
      
      
      
      
      
      
      
      
      
      
      
      

