module.exports = (module) -> 
  index =
    module: module
    myView: module.view('my_view', init:true)
