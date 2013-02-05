##= require jquery
##= require jquery_ujs
##= require_tree ../../../vendor/assets/javascripts/jqueryExtras

##= require hamlcoffee

##= require_tree ../../../vendor/assets/javascripts/misc

##= require underscore
##= require backbone

##= require_tree ../../../vendor/assets/javascripts/BackBoneExtras

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

















