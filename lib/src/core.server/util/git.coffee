{exec} = require 'child_process'
util   = require('./common')

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
      onExec = options.onExec ?= true
      
      # Prepare the command to execute.
      if dir?
        cmd = "git --git-dir=#{dir}/.git --work-tree=#{dir} #{cmd}"
      else
        cmd = "git #{cmd}"

      # Execute the command.
      exec cmd, (err, stdout, stderr) ->
          util.onExec(err, stdout, stderr) if onExec
          callback?(err, stdout, stderr)

  ###
  Adds all items (using . and -u) and commits them to the repository.
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
      console.log 'Committing...'
      
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
              util.log 'Nothing to commit', color.red
            else
              util.onExec err, stdout, stderr
              util.log 'Commit done', color.green
            callback?(err, stdout, stderr)
          
      fnAdd -> fnCommit()
      
