##= require jquery
##= require jquery_ujs
##= require jquery.hoverIntent
##= require hamlcoffee

##= require underscore
##= require backbone

##= require_self

##= require_tree ../templates/dashboard
##= require_tree ./backbone/models/dashboard
##= require_tree ./backbone/collection/dashboard
##= require_tree ./backbone/views/dashboard
##= require_tree ./backbone/routers/dashboard

##= require backbone-associations-min.js

##= require application.js

window.Weightyplates =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  init: -> #alert "Here"
    new Weightyplates.Routers.Dashboard()
    Backbone.history.start()

$(document).ready ->
  Weightyplates.init()















