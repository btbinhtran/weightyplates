class Weightyplates.Routers.Dashboard extends Backbone.Router
  routes:
    '': 'index'
    'entry/:id': 'show'

  initialize: ->
    @collection = new Weightyplates.Collections.DashboardItems()
    @collection.fetch()


  index: ->
    view = new Weightyplates.Views.DashboardIndex(collection: @collection)
    $('#container').html(view.render().el)


  show: (id) ->
    alert "Entry #{id}"