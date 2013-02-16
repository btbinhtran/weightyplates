##= require jquery
##= require jquery_ujs
##= require hamlcoffee

##= require underscore
##= require backbone

##= require_self

##= require_tree ../templates/calculator
##= require_tree ./backbone/models/calculator
##= require_tree ./backbone/collection/calculator
##= require_tree ./backbone/views/calculator
##= require_tree ./backbone/routers/calculator


window.Weightyplates =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  init: -> #alert "Here"
    new Weightyplates.Routers.Calculator
    Backbone.history.start()

$ ->
  Weightyplates.init()
