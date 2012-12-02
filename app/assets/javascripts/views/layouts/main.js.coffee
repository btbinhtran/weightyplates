class WPApp.Views.Layouts.Main extends Backbone.Marionette.Layout
  template: 'layouts/main'
  regions:
    dashboard: '#dashboard'

WPApp.addInitializer ->
  WPApp.layouts.main = new WPApp.Views.Layouts.Main