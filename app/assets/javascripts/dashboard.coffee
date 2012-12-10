##= require jquery
##= require jquery_ujs

##= require underscore
##= require backbone

##= require_self

##= require_tree ../templates
##= require_tree ./backbone/models
##= require_tree ./backbone/views
##= require_tree ./backbone/routers
##= require_tree .

window.Weightyplates =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  init: -> #alert "Here"
    new Weightyplates.Routers.Dashboard
    Backbone.history.start()

$(document).ready ->

  Weightyplates.init()














