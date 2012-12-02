class WPApp.Controllers.Exercises
  constructor: ->
    @collection = new WPApp.Collections.Exercises
    main = $('#dashboard')

  index: ->
    view = new WPApp.Views.Exercises
      collection: @collection
    WPApp.dashboard.show(view)

class WPApp.Routers.Exercises extends Backbone.Marionette.AppRouter
  appRoutes:
    '': 'index'