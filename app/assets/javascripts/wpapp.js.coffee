@WPApp = new Backbone.Marionette.Application

WPApp.module 'Models'
WPApp.module 'Collections'
WPApp.module 'Views'
WPApp.module 'Controllers'
WPApp.module 'Routers'

$(document).ready ->
  MyApp.start()
