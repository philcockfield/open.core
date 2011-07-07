module.exports =
  javascript: require './javascript'

  send:
    ###
    Writes the given JavaScript to the response stream with the correct type.
    @param response to write to.
    @param code to send.
    ###
    script: (response, code) ->
        response.send code, 'Content-Type': 'text/javascript'
