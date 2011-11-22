http = require 'http'

###
Helpers for working with HTTP.
###
module.exports = 
  
  ###
  Issues a POST request against an endpoint.
  @param options
          - data:  An object contining the data to post.
          - host:  The host URL (eg. www.google.com).
          - port:  The port to post on (optional - default: 80).
          - path:  The path within the host to post to (eg. /item/123)
  @param callback(err, result) : Invoked upon completion.
  ###
  post: (options = {}, callback) -> 
    
    # Setup initial conditions.
    data = options.data ? {}
    port = options.port ? 80
    host = options.host
    path = options.path ? '/'
    throw new Error('No host URL provided.') unless host?
    
    # Prepare the data.
    if _(data).isString()
      contentType = 'text/plain'
    else
      contentType = 'application/json'
      data = JSON.stringify(data)
    
    # Create the request.
    client  = http.createClient port, host
    headers =
     'host':           host
     'Content-Type':   contentType
     'Content-Length': data.length
    req = client.request 'POST', path, headers
    
    # Wire up events.
    req.on 'response', (res) -> 
      data = ''
      res.on 'data', (chunk) -> data += chunk.toString()
      res.on 'end', -> 
        callback? null, 
          statusCode: res.statusCode
          headers:    res.headers
          response:   res
          data:       data
    
    req.on 'error', (err) -> 
      callback? err
      callback = null # Prevent any further callbacks.
    
    # Invoke the request.
    req.write data
    req.end()
  