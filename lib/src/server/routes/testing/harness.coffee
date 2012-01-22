core       = require '../../../server'
TestRunner = require './test_runner'

###
Configures the TestHarness page.
@param app express/connect that the test runner is operating within.
@param options:
        - url         : (optional) The URL that loads the test-runner (defaults to /specs).
        - title       : (optional) The page title (defaults to 'Specs').
        - specsDir    : The path to the directory containing the client-side specs.
        - sourceUrls  : An array or URLs (or a single URL) pointing to the source script(s)
                        that are under test.
###
module.exports = (app, options = {}) -> 
      new Harness(app).init(options)


class Harness extends TestRunner
  constructor: (app) -> 
      super app, view: 'testing/harness'

