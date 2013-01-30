##= require jquery
##= require jquery_ujs

##= require jquery.hoverIntent
##= require hamlcoffee
##= require parser
##= require date.format

##= require underscore
##= require backbone

##= require Backbone.validateAll
##= require backbone-associations

##= require_self

##= require_tree ../templates/dashboard
##= require_tree ./backbone/models/dashboard/workoutForm
##= require_tree ./backbone/models/preloadModels/dashboard
##= require_tree ./backbone/collection/dashboard
##= require_tree ./backbone/views/dashboard
##= require_tree ./backbone/routers/dashboard

##= require application

window.Weightyplates =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  init: ->
    new Weightyplates.Routers.Dashboard()
    Backbone.history.start()

$(document).ready ->
  Weightyplates.init()

















