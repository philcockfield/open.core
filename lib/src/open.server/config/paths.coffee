fs    = require 'fs'
root  = fs.realpathSync("#{__dirname}/../../../..")
lib   = "#{root}/lib"
paths =
    root:         root
    lib:          lib
    public:       "#{lib}/public"
    javascripts:  "#{lib}/public/javascripts"
    stylesheets:  "#{lib}/public/stylesheets"
    images:       "#{lib}/public/images"
    views:        "#{lib}/views"
    src:          "#{lib}/src"
    server:       "#{lib}/src/open.server"
    client:       "#{lib}/src/open.client"
    test:         "#{root}/test"
    specs:        "#{root}/test/specs"
module.exports = paths

# Put the root modules into the global paths.
# require.paths.unshift paths.client
require.paths.unshift paths.src