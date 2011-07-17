fs = require 'fs'

root  = process.env.PWD
lib   = "#{root}/lib"

paths =
    root:   root
    lib:    lib
    public: "#{lib}/public"
    views:  "#{lib}/views"
    src:    "#{lib}/src"
    server: "#{lib}/src/core.server"
    client: "#{lib}/src/core.client"
    test:  "#{root}/test"
    specs:  "#{root}/test/specs"
module.exports = paths

# Put the root modules into the global paths.
require.paths.unshift paths.src
