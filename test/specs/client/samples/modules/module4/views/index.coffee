module.exports = (module) -> 
  index =
    module: module
    myView: module.require.view('my_view', init:true)
