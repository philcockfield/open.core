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
  incrementPackage: (package) -> package.version = version.next(package.version)


  ###
  Syncs the dependency in the given package with the current
  version of the given dependency package.
  @param package    : The package to sync.
  @param dependency : The dependency package to sync with.
  ###
  syncDependency: (package, dependency) ->
    for key of package.dependencies
      if key == dependency.name
          value = package.dependencies[key]
          package.dependencies[key] = dependency.version

