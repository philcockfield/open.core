testRunner = require './test_runner'

###
Configures the Jasmine BDD spec runner.
@param app express/connect that the test runner is operating within.
@param options:
        - url         : (optional) The URL that loads the test-runner (defaults to /specs).
        - title       : (optional) The page title (defaults to 'Specs').
        - specsDir    : The path to the directory containing the client-side specs.
        - sourceUrls  : An array or URLs (or a single URL) pointing to the source script(s)
                        that are under test.
        - samplesDir:   Optional. The path to a directory of samples to compile and serve as commonJS modules.
###
module.exports = (app, options) -> 
      testRunner(app, options)
