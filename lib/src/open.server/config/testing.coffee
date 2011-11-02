core    = require 'open.server'
app     = core.app
baseUrl = core.baseUrl

# Paths.
stylesheets = "#{baseUrl}/stylesheets/core"
sourceUrls = [
  "#{baseUrl}/libs.js"
  "#{baseUrl}/core+controls.js" 
  "#{baseUrl}/harness.js" 
  "#{baseUrl}/auth.js" 
]


# Unit-test runner (specs).
core.configure.specs app,
      title:            'Open.Core - Specs'
      url:              "#{baseUrl}/specs"
      sourceUrls:       sourceUrls
      specsDir:         "#{core.paths.specs}/client/"
      samplesDir:       "#{core.paths.specs}/client/samples"
      samplesNamespace: 'core/test'

# Test Harness.
core.configure.harness app,
      title:      'Open.Core - TestHarness'
      url:        "#{baseUrl}/harness"
      sourceUrls: sourceUrls
      specsDir:   "#{core.paths.test}/harness/"
      css:        [
                    "#{stylesheets}/base.css"
                    "#{stylesheets}/controls.css"
                    "#{stylesheets}/modules.css"
                  ]

