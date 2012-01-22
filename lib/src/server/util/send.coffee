module.exports =
  ###
  Writes the given JavaScript to the response stream with the correct type.
  @param response to write to.
  @param code to send.
  ###
  script: (response, script) -> response.send script, 'Content-Type': 'text/javascript'

  ###
  Writes the contents of the given JavaScript file to the response stream.
  @param response to write to.
  @param file to send.
  ###
  scriptFile: (response, file) -> response.sendfile file, 'Content-Type': 'text/javascript'

  ###
  Writes the contents of the given JSON file to the response stream.
  @param response to write to.
  @param file to send.
  ###
  jsonFile: (response, file) -> response.sendfile file, 'Content-Type': 'application/json'
  
  ###
  Writes the contents of the given CSS file to the response stream.
  @param response to write to.
  @param file to send.
  ###
  cssFile: (response, file) -> response.sendfile file, 'Content-Type': 'text/css'
