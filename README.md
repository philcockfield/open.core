# Open.Core
Common utility functionality used between multiple applications.

[Live demo](http://opencore.herokuapp.com/harness).

## Setup
### Install using NPM

    npm install open.core

### Initialize
To initialize the **open.core** library from [Express](http://expressjs.com/):

```coffeescript

  express = require 'express'
  core    = require 'open.server'

  app = express.createServer()
  core.configure app
  app.listen 8000

```

### Tests

To run server side tests, from the `open.core` module folder: `$ cake specs`
Make sure Jasmine-Node has been installed globally: `npm install -g jasmine-node`

To run client-side tests in browser:

1. Configure **open.core** in your host application (see above).
2. Run tests in the browser at: `http://localhost:8000/core/specs`

To use the [Jasmine](http://pivotal.github.com/jasmine/) test runner in the browser from your
host application:

```coffeescript

  core = require 'open.server'
  core.configure.specs app,
            title:      'My Specs'
            url:        '/specs'
            specsDir:   "#{__dirname}/specs/client/"
            sourceUrls: [
                '/javascripts/libs.js'
                '/javascripts/app.js' ]

```


## Optional Dependencies
Some features require non-NPM installable dependencies.  These are optional.

- [Pygments](http://pygments.org/docs/installation/)  
  Source code highlighting. Requires [Python](http://python.org/).
  
  - To install: `sudo easy_install Pygments`
  - See server class: `core.util.Pygments`



## License

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