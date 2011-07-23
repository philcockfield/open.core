server = require(process.env.PWD)

global.core = server
global.test =
    paths: server.paths
    server: server
    client: server.client


