#Open.Core
Common utility functionality used between multiple applications.

--------

### Install using NPM

    npm install open.core


### Initialize
To initialize the **Open.Core** library from [Express](http://expressjs.com/):

```coffeescript

  express = require 'express'
  core    = require 'open.core'

  app = express.createServer()
  core.configure(app)
  app.listen 8000

```


### Tests

To run server side tests, from the `open.core` module folder: `$ cake specs`

To run client-side tests in browser:

1. Configure **open.core** in your hosting application: `require('open.core').configure(app);`
2. Run tests in the browser at: `http://localhost:8000/core/specs`

To use the [Jasmine](http://pivotal.github.com/jasmine/) test runner from your hosting application:

```coffeescript

  core = require 'open.core'
  core.configure.specs app,
            title:      'TestHarness Specs'
            url:        '/specs'
            specsDir:   "#{paths.specs}/client/"
            sourceUrls: '/javascripts/harness.js'


```


## Licence

The [MIT License](http://www.opensource.org/licenses/mit-license.php) (MIT)  
Copyright © 2011 Phil Cockfield

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.