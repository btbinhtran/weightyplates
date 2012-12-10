class Weightyplates.Routers.Dashboard extends Backbone.Router
  routes:
    '': 'index'
    'entry/:id': 'show'

  initialize: ->
    @collection = new Weightyplates.Collections.DashboardItems()
    @collection.fetch()
    #console.log('render')

  index: ->
    #view = new Weightyplates.Views.DashboardIndex()
    view = new Weightyplates.Views.DashboardIndex(collection: @collection)
    $('#container').html(view.render().el)



    viewButton = new Weightyplates.Views.WorkoutEntryButton()
    #$('#add-workout').html(viewButton.render().el)
    $('.add-workout-button-area').html(viewButton.render().el)

  show: (id) ->
    alert "Entry #{id}"