fs    = require 'fs'
root  = fs.realpathSync("#{__dirname}/../../../..")
lib   = "#{root}/lib"


module.exports = paths =
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


# Put the root module into the global paths.
# NOTE: Only do this if another reference to [open.core] has not
#       already been registered.  This will happen if there is more 
#       than one dependency reference to [open.core].
# unless _(require.paths).include 'node_modules/open.core/'
#   require.paths.unshift paths.src
# unless _(process.env.NODE_PATH).include 'node_modules/open.core/'
#   console.log "IN UNLESS"
#   process.env.NODE_PATH = "#{process.env.NODE_PATH}:#{paths.src}"
# 
# console.log 'NODE_PATH: ', process.env.NODE_PATH

