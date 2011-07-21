index =
  version: require './_version'


# Export
_.extend index, require('./_common')
module.exports = index

