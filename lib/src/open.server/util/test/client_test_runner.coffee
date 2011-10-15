# {exec}        = require 'child_process'
# child_process = require 'child_process'
# zombie        = require 'zombie'
# common        = require '../common'
# onExec        = common.onExec
# 
# 
# ###
# Runs client unit-tests in a new node process.
# ###
# module.exports = class ClientTestRunner
#   
#   ###
#   Constructor.
#   @param options:
#           - app:    (optional) The name (and optionally path) to the .js file that 
#                                is the entry-point for the node process (default: 'app.js')
#           - port:   (optional) The port to run the node process on (default: 8888).
#           - path:   (optional) The url path to the specs. This is appended to [localhost:port] (default: '/').
#           - silent: (optional) Flag indicating if output should be written to the console. (default: false)
#   ###
#   constructor: (options = {}) -> 
#       
#       # Setup initial conditions.
#       @app    = options.app ?= 'app.js'
#       @port   = options.port ?= 8888
#       @path   = options.path ?= '/'
#       @silent = options.silent ?= false
#   
#   
#   passed:      null # Gets whether the specs passed.  True/False or Null if tests have not been run.
#   total:       null # Gets the total number of specs (null if tests have not been run).
#   totalFailed: null # Gets the total number of failures (null if tests have not been run).
#   totalPassed: null # Gets the total number of successes (null if tests have not been run).
#   elapsedSecs: null # Gets the time, in seconds, the tests took to run (null if tests have not been run).
#   summary:     null # Gets the raw summary text from Jasmine.
#   
#   
#   ###
#   Starts a new node process and runs the unit tests in it. 
#   The method looks for the word 'Started' in stdout.  Ensure the server reports it's startup state to the console.
#   @param callback : Function to invoke when complete.  See property on the object for results.
#   ###
#   run: (callback) -> 
# 
#       # 1. Start a node process to serve the test-runner, specs and code.
#       @log 'Starting', color.blue, 'node process to run client unit-tests' 
#       @_startNode => 
#         
#         # 2. Run the unit-tests.
#         @_runSpecs (args) =>
#             
#             # Store result state as properties.
#             _(@).extend args
#             
#             # Write summary to console.
#             logColor = if @passed then color.green else color.red
#             @log " #{@summary}", logColor
#             @log()
#             @_logFailures()
#             
#             # Finish up.
#             @dispose()
#             callback?()
#   
#   
#   ###
#   Disposes of any running node process.
#   ###
#   dispose: -> @_killProcess()
#   
#   
#   # PRIVATE --------------------------------------------------------------------------
#   
#   
#   log: (message, color = '', explanation = '') -> common.log(message, color, explanation) unless @silent is yes
#   
#   _startNode: (callback) -> 
#     
#       # Prepare environment variables to pass to the node process.
#       env = _(process.env).clone()
#       env.PORT = @port
#       
#       # Start the process.
#       @childProcess = child_process.spawn('node', [ @app ], { env:env })
#       @childProcess.stdout.on 'data', (data) -> 
#           started = _(data.toString().toLowerCase()).include 'started'
#           if started is yes
#               callback?()
#               callback = null
#   
#   _killProcess: -> @childProcess?.kill()
#   
#   _runSpecs: (callback) -> 
#       
#       # Setup initial conditions.
#       path = _(@path).ltrim('/')
#       url  = "http://localhost:#{@port}/#{path}"
#       args = {}
#       
#       exit = () => 
#           @_killProcess()
#           callback? args
#       
#       # Visit the page containing the test runner.
#       @log " - Running client tests on #{url}"
#       zombie.visit url, (err, browser, status) => 
#           if err?
#               @log err, color.red
#               exit()
#               return
#           
#           # Check the results
#           get = (selector) -> $(browser.querySelector(selector))
#           args.passed = get('.runner.passed').length is 1
#           args.failures = @_failures(browser) if args.passed is no
#           
#           passedDesc = get '.runner.passed .description'
#           failedDesc = get '.runner.failed .description'
#           args.summary  = if args.passed then passedDesc.html() else failedDesc.html()
#           @_setTotals args
#           
#           # Finish up.
#           exit()
#   
#   _setTotals: (args) -> 
#       
#       # Setup initial conditions.
#       text = _(args.summary).trim()
#       process = (matches, fnFormat) -> 
#                               return null unless matches? and matches[0]?
#                               fnFormat matches[0]
#       
#       # Total specs.
#       args.total = process text.match(/^\d+ spec/g), (total) ->
#                               total = _(total).strLeft ' spec'
#                               parseInt total
#       # Total failures.
#       args.totalFailed = process text.match(/\d+ failure/g), (failed) -> 
#                               failed = _(failed).strLeft ' failure'
#                               parseInt failed
#       # Total passed
#       args.totalPassed = args.total - args.totalFailed
#       
#       # Elapsed time.
#       args.elapsedSecs = process text.match(/in \d+.?\d*s$/g), (elapsed) -> 
#                               elapsed = _(elapsed).rtrim 's'
#                               elapsed = _(elapsed).strRight 'in '
#                               parseFloat elapsed
#       
#   
#   _failures: (browser) -> 
#       
#       # Setup initial conditions.
#       failures = []
#       elRoot = $(browser.querySelector('.jasmine_reporter'))
#       
#       # Extract the description.
#       description = (elParent) -> elParent.children('.description').html()
#       
#       # Extract details of failed specs.
#       specs = (elSuite) -> 
#             results = []
#             for elSpec in elSuite.children('.spec.failed')
#                     elSpec = $(elSpec)
#                     spec = 
#                         it:      description(elSpec)
#                         message: elSpec.find('.resultMessage.fail').html()
#                     results.push spec
#             results
#       
#       # RECURSIVE - Processes the 'failed suites' extracting details.
#       processSuite = (elParent, suites) -> 
#             for elFailedSuite in elParent.children('.suite.failed')
#                 
#                 # Create the suite object.
#                 elFailedSuite = $(elFailedSuite)
#                 suite = 
#                     describe:  description(elFailedSuite)
#                     specs:     specs(elFailedSuite)
#                     suites:    []
#                 
#                 # Append collection.
#                 suites.push suite
#                 
#                 # Add sub-suites  <-- RECURSION.
#                 processSuite elFailedSuite, suite.suites
#       
#       # Start processing at the root level of the results.
#       processSuite elRoot, failures
#       
#       # Finish up.
#       failures
#       
#       
#   _logFailures: -> 
#       INDENT = 2
#       
#       # Setup initial conditions.
#       return unless @failures? and @failures.length > 0
#       return if @silent is yes
#       @log ' Failures:', color.red
#       
#       indent = 3
#       log = (message, color = '', explanation = '') => 
#             pad = _.lpad '', indent
#             message = pad + message
#             @log message, color, explanation
#       
#       logFailures = (failures) -> 
#           # Log each suite of specs in the set.
#           for suite in failures
#             log 'describe:', color.blue, suite.describe
#             
#             # Log each spec in the suite.
#             indent += INDENT
#             for spec in suite.specs
#                 log 'it', color.blue, spec.it
#                 indent += INDENT
#                 log spec.message, color.red
#                 indent -= INDENT
#                 
#             indent -= INDENT
#             
#             # Log child-suites. <== RECURSION.
#             if suite.suites.length > 0
#                 indent += INDENT
#                 logFailures suite.suites
#       
#       # Start logging the hierarchy of errors at the root.
#       logFailures @failures
#       @log()
# 
