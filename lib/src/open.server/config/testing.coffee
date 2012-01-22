core    = require '../'
app     = core.app
baseUrl = core.baseUrl


# Paths.
stylesheets = "#{baseUrl}/stylesheets/core"


# Unit-test runner (specs).
core.init.specs app,
      title:            'Open.Core - Specs'
      url:              "#{baseUrl}/specs"
      sourceUrls:       [
                          "#{baseUrl}/libs.js" 
                          "#{baseUrl}/harness.js" # Includes core + controls.
                          "#{baseUrl}/auth.js" 
                        ]
      specsDir:         "#{core.paths.specs}/client/"
      samplesDir:       "#{core.paths.specs}/client/samples"
      samplesNamespace: 'core/test'

# Test Harness.
core.init.harness app,
      title:      'Open.Core - TestHarness'
      url:        "#{baseUrl}/harness"
      sourceUrls: [
                    "#{baseUrl}/auth.js" 
                  ]
      specsDir:   "#{core.paths.test}/harness/"
      css:        [
                    "#{stylesheets}/base.css"
                    "#{stylesheets}/controls.css"
                    "#{stylesheets}/modules.css"
                    "#{baseUrl}/stylesheets/dev/test.css"
                  ]
      samplesDir: "#{core.paths.test}/harness/samples"
      samplesNamespace: 'core/test'

