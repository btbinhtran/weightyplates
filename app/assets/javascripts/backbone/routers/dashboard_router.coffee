class Weightyplates.Routers.Dashboard extends Backbone.Router
  routes:
    '': 'index'
    'entry/:id': 'show'

  initialize: ->
    @model = new Weightyplates.Models.Dashboard()
    @model.fetch()

  index: ->
    view = new Weightyplates.Views.DashboardIndex(model: @model)
    $('#container').html(view.render().el)

  show: (id) ->
    alert "Entry #{id}"