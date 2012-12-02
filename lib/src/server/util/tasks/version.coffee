{exec}  = require 'child_process'
fs      = require 'fs'

module.exports = version =
  ###
  Increments to the next version.
  @param version to increment.
  ###
  next: (version) ->
      return unless version?
      parts = version.split('.')
      parts[parts.length - 1] = parseInt(parts[parts.length - 1]) + 1
      version = ''
      version += part + '.' for part in parts
      version.substr(0, version.length - 1)
  
  ###
  Increments the version of the given package.
  @param package : {object}. The [package.json] to increment.
  ###
  incrementPackage: (pkg) -> pkg.version = version.next(pkg.version)


  ###
  Syncs the dependency in the given package with the current
  version of the given dependency package.
  @param package    : The package to sync.
  @param dependency : The dependency package to sync with.
  ###
  syncDependency: (pkg, dependency) ->
    for key of pkg.dependencies
      if key == dependency.name
          value = pkg.dependencies[key]
          pkg.dependencies[key] = dependency.version

