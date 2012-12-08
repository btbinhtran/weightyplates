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

  hideAddWorkoutDialog = ->
    $('.dashboard-add-workout-modal-row-show').addClass("dashboard-add-workout-modal-row").removeClass("dashboard-add-workout-modal-row-show")

  $("#add-workout").click ->
    @blur()
    $(".dashboard-add-workout-modal-row").addClass("dashboard-add-workout-modal-row-show  row-fluid").removeClass "dashboard-add-workout-modal-row"

  $('#collapse-button').click ->
    hideAddWorkoutDialog()

  $(document).on "keypress", (event) ->
    hideAddWorkoutDialog() if event.keyCode == 27








