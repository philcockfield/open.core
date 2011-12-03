express = require 'express'
core    = require(process.env.PWD)

# Initialize the server.
core.init express.createServer(), baseUrl: '/'


global.core = core
global.test =
  paths: core.paths
  server: core
  client: core.client
  
  authKeys:
    twitter:
      key:    'TWITTER_KEY'
      secret: 'TWITTER_SECRET'
    
    facebook:
      key:    'FACEBOOK_KEY'
      secret: 'FACEBOOK_SECRET'
    
    linkedIn:
      key:    'LINKED_IN_KEY'
      secret: 'LINKED_IN_SECRET'
  


