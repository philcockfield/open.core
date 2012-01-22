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
    server:       "#{lib}/src/server"
    client:       "#{lib}/src/client"
    test:         "#{root}/test"
    specs:        "#{root}/test/specs"


