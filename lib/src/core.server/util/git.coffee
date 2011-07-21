{exec}  = require 'child_process'

module.exports =
  ###
  Executes the given git command.
  @param cmd      : Git command to execute.
  @param options
                  - dir: (optional) The directory the git repository is in (default current).
  @param callback(err, stdout, stderr)
  ###
  exec: (cmd, options..., callback) ->
     options = options[0] ?= {}
     dir = options.dir

     if dir?
        cmd = "git --git-dir=#{dir}/.git --work-tree=#{dir} #{cmd}"
     else
        cmd = "git #{cmd}"
     exec cmd, callback
