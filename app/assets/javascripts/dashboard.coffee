##= require jquery
##= require jquery_ujs
##= require bootstrap-all


#= require_tree ./backbone/templates
#= require_tree ./backbone/models
#= require_tree ./backbone/views
#= require_tree ./backbone/routers

$(document).ready ->
  $("#add-workout").click ->
    $(".dashboard-add-workout-modal-row").addClass("dashboard-add-workout-modal-row-show  row-fluid").removeClass "dashboard-add-workout-modal-row"




