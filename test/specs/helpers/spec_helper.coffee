paths = require "#{__dirname}/../../../lib/src/server/config/paths"

global.test =
    paths: paths
    server: require 'core.server'
#    client: require 'core.client'


