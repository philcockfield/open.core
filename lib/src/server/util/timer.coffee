###
Helper class for calculating elapsed time.
###
module.exports = class Timer
  constructor: (@startTime) -> 
      @startTime ?= now()
  
  # Sets a stop time.
  stop: -> @stopTime = now()
  
  # Retrieves the elapsed time in milliseconds.
  # Time is calcualted from now (or the stop-time if [stop] has been called).
  msecs: -> 
    stopTime = @stopTime ?= now()
    stopTime - @startTime
  
  # Retrieves the elapsed time in seconds.
  # Time is calcualted from now (or the stop-time if [stop] has been called).
  secs: () -> 
      secs = @msecs() / 1000
      Math.round(secs * 10) / 10
  


# PRIVATE --------------------------------------------------------------------------
  
now = -> new Date().getTime()

