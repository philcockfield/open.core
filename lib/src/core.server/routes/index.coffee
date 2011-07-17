module.exports =
  ###
  Initializes the routes.
  @param core: the root Open.Core server module.
  ###
  init: (core) ->
      # Setup initial conditions.
      app     = core.app
      paths   = core.paths
      send    = core.util.send

      @core     = core
      @app      = app
      @paths    = paths
      @baseUrl  = core.baseUrl
      @send     =  send

      # Prepare the base-url for passing to templates.
      @baseUrl  = '' unless @baseUrl?
      @baseUrl  = '' if @baseUrl is '/'


      # Initialize sibling route modules.
      require('./specs').init @

      # Routes.
      # Send from file.
      app.get "#{@baseUrl}/libs:min?.js", (req, res) ->
            libs = "#{paths.public}/javascripts/libs"
            min = ''
            min = '-min' if req.params.min == '-min'
            core.util.send.scriptFile res, "#{libs}/libs#{min}.js"


  ###
  Renders the specified template from the 'views' path.
  @param response object to write to.
  @param template: path to the template within the 'views' folder.
  @param options: variables to pass to the template.
  ###
  render: (response, template, options) ->
          extension = options.extension ?= 'jade'
          options.baseUrl ?= @baseUrl
          response.render "#{@paths.views}/#{template}.#{extension}", options
