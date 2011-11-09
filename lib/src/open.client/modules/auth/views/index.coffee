module.exports = (module) ->
  index =
    SignIn:         module.view 'sign_in'
    ProviderButton: module.view 'provider_btn'