core    = require 'open.server'
app     = core.app
baseUrl = core.baseUrl


sourceUrls = [
  "#{baseUrl}/libs.js"
  "#{baseUrl}/core+controls.js" 
  "#{baseUrl}/harness.js" 
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
      css:        ["#{baseUrl}/stylesheets/core/base.css", "#{baseUrl}/stylesheets/core/controls.css"]

