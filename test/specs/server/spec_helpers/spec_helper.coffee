server = require(process.env.PWD)

global.core = server
global.test =
  paths: server.paths
  server: server
  client: server.client
  
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
  


