{exec}        = require 'child_process'
child_process = require 'child_process'
zombie        = require 'zombie'
common        = require '../common'
onExec        = common.onExec


###
Runs client unit-tests in a new node process.
###
module.exports = class ClientTestRunner
  
  ###
  Constructor.
  @param options:
          - app:    (optional) The name (and optionally path) to the .js file that 
                               is the entry-point for the node process (default: 'app.js')
          - port:   (optional) The port to run the node process on (default: 8888).
          - path:   (optional) The url path to the specs. This is appended to [localhost:port] (default: '/').
          - silent: (optional) Flag indicating if output should be written to the console. (default: false)
  ###
  constructor: (options = {}) -> 
      
      # Setup initial conditions.
      @app    = options.app ?= 'app.js'
      @port   = options.port ?= 8888
      @path   = options.path ?= '/'
      @silent = options.silent ?= false
  
  
  passed:      null # Gets whether the specs passed.  True/False or Null if tests have not been run.
  total:       null # Gets the total number of specs (null if tests have not been run).
  totalFailed: null # Gets the total number of failures (null if tests have not been run).
  totalPassed: null # Gets the total number of successes (null if tests have not been run).
  elapsedSecs: null # Gets the time, in seconds, the tests took to run (null if tests have not been run).
  summary:     null # Gets the raw summary text from Jasmine.
  
  
  ###
  Starts a new node process and runs the unit tests in it. 
  The method looks for the word 'Started' in stdout.  Ensure the server reports it's startup state to the console.
  @param callback : Function to invoke when complete.  See property on the object for results.
  ###
  run: (callback) -> 
      # Start a node process to serve the test-runner, specs and code.
      @_startNode => 
        @_runSpecs (args) =>
            
            # Store result state as properties.
            @passed  = args.passed
            @summary = args.text
            @_setTotals args
            
            # Finish up.
            @dispose()
            callback?()
  
  
  ###
  Disposes of any running node process.
  ###
  dispose: -> @_killProcess()
  
  
  # PRIVATE
  
  
  log: (message, color = '', explanation = '') -> common.log(message, color, explanation) unless @silent is yes
  
  _startNode: (callback) -> 
    
      # Prepare environment variables to pass to the node process.
      env = _(process.env).clone()
      env.PORT = @port
      
      # Start the process.
      @log "Starting node process to run client unit-tests"
      @childProcess = child_process.spawn('node', [ @app ], { env:env })
      @childProcess.stdout.on 'data', (data) -> 
          started = _(data.toString().toLowerCase()).include 'started'
          if started is yes
              callback?()
              callback = null
  
  _killProcess: -> @childProcess?.kill()
  
  _runSpecs: (callback) -> 
      
      # Setup initial conditions.
      path = _(@path).ltrim('/')
      url  = "http://localhost:#{@port}/#{path}"
      args = {}
      
      exit = () => 
          @_killProcess()
          callback? args
      
      # Visit the page containing the test runner.
      @log " - Running client tests on #{url}"
      zombie.visit url, (err, browser, status) => 
          if err?
              @log err, color.red
              exit()
              return
          
          # Check the results
          get = (selector) -> $(browser.querySelector(selector))
          args.passed = get('.runner.passed').length is 1
          passedDesc = get '.runner.passed .description'
          failedDesc = get '.runner.failed .description'
          args.text  = if args.passed then passedDesc.html() else failedDesc.html()
          logColor   = if args.passed then color.green else color.red
          
          # Write results to console.
          @log " #{args.text}", logColor
          @log()
          exit()
  
  _setTotals: (args) -> 
      match = (pattern) -> 
                regex = new RegExp pattern, 'g'
                matches = args.text.match regex
                if matches? then matches[0] else null
      
      # Total number of tests.
      total = match '^\d+ specs'
      total = _(total).strLeft ' specs'
      @total = parseInt total
      
      # Total failures.
      failed = match '\d+ failures'
      
      failed = _(failed).strLeft ' failures'
      @totalFailed = parseInt failed
      
      # Total passed
      @totalPassed = @total - @totalFailed
      
      # Elapsed time.
      elapsed = match 'in \d+.?\d*s$'
      elapsed = _(elapsed).rtrim 's'
      elapsed = _(elapsed).strRight 'in '
      @elapsedSecs = parseFloat elapsed
      
