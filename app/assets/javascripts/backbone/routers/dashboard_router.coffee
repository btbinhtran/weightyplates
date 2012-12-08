class Weightyplates.Routers.Dashboard extends Backbone.Router
  routes:
    '': 'index'
    'entry/:id': 'show'

  index: ->
    view = new Weightyplates.Views.DashboardIndex
    $('#container').html(view.render().el)

  show: (id) ->
    alert "Entry #{id}"