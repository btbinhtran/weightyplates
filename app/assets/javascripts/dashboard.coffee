##= require jquery
##= require jquery_ujs
##= require bootstrap-all

##= require underscore
##= require backbone

##= require_tree ./backbone/templates
##= require_tree ./backbone/models
##= require_tree ./backbone/views
##= require_tree ./backbone/routers


window.Weightyplates =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  init: -> alert "Here"

$(document).ready ->
  Weightyplates.init()
  $("#add-workout").click ->
    $(".dashboard-add-workout-modal-row").addClass("dashboard-add-workout-modal-row-show  row-fluid").removeClass "dashboard-add-workout-modal-row"
    #alert "something"





