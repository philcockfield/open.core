server = require process.env.PWD

global.test =
    paths: server.paths
    server: server
    client: require 'core.client'


