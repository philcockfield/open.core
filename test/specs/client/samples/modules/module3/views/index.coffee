module.exports = (module) -> 
  index =
    module: module
    myView: require('./my_view')(module)
