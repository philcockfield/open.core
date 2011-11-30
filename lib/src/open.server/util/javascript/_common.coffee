module.exports = 
  ###
  Returns a [Function] with two properties:
    - standard: the uncompressed code.
    - minified: the compressed code.
  The function can be invoked like so:
    fn(minified):
      - minified: true  - returns the compressed code.
      - minified: false - returns the uncompressed code.
  ###
  codeFunction: (standardCode, minifiedCode) -> 
    fn = (minified) -> 
          if minified then minifiedCode else standardCode
    fn.standard = standardCode
    fn.minified = minifiedCode
    fn
  