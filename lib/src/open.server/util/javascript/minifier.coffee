jsp = require('uglify-js').parser
pro = require('uglify-js').uglify

module.exports =
  ###
  Compresses the code.
  @param code: to minify
  @returns the minified code.
  ###
  compress: (code) ->

        # NB: This sequence taken from the README for UglifyJS
        # https://github.com/mishoo/UglifyJS
        # This performs the full compression that is possible right now.

        ast = jsp.parse(code)          # Parse code and get the initial AST
        ast = pro.ast_mangle(ast)      # Get a new AST with mangled names
        ast = pro.ast_squeeze(ast)     # Get an AST with compression optimizations
        pro.gen_code(ast)              # Compress code here
