@WPApp = new Backbone.Marionette.Application

WPApp.module 'Models'
WPApp.module 'Collections'
WPApp.module 'Views'
WPApp.module 'Views.Layouts'
WPApp.module 'Layouts'
WPApp.module 'Controllers'
WPApp.module 'Routers'

WPApp.module 'layouts'

WPApp.addInitializer ->
  WPApp.addRegions
    dashboard: '#dashboard'
  exercisesController = new WPApp.Controllers.Exercises()
  new WPApp.Routers.Exercises(controller: exercisesController)
  Backbone.history.start



$(document).ready ->
  console.log WPApp
  WPApp.start
    dashboard: '#dashboard'

