jsp = require('uglify-js').parser
pro = require('uglify-js').uglify

module.exports =
  ###
  Compresses the code.
  @param code: to minify
  @param callback(code): invoked when complete with the produced code.  Passes minified code
  ###
  compress: (code, callback) ->

        # NB: This sequence taken from the README for UglifyJS
        # https://github.com/mishoo/UglifyJS
        # This performs the full compression that is possible right now.

        ast = jsp.parse(code)          # Parse code and get the initial AST
        ast = pro.ast_mangle(ast)      # Get a new AST with mangled names
        ast = pro.ast_squeeze(ast)     # Get an AST with compression optimizations
        code = pro.gen_code(ast)       # Compress code here
        callback?(code)
