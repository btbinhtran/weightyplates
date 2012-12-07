#= require_self

#= require_tree ./backbone/templates
#= require_tree ./backbone/models
#= require_tree ./backbone/views
#= require_tree ./backbone/routers

window.Weightyplates =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  init: -> alert "Here"

$(document).ready ->
  Weightyplates.init()
