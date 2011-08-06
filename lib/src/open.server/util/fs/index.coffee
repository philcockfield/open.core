###
Module Exports
###
module.exports = index =
  concatenate: require './concatenate'

# Copy common methods onto the index.
_.extend index, 
    require './_common'
    require './_write'
    require './_copy'
    require './_delete'
    require './_create_dir'
    require './_read_dir'
    require './_flatten_dir'

