class Weightyplates.Routers.Dashboard extends Backbone.Router
  routes:
    '': 'index'

  initialize: ->
    @collection = new Weightyplates.Collections.DashboardItems([
      new Weightyplates.Models.DashboardState(),
      new Weightyplates.Models.WorkoutFormInputs()
    ])

    @collection.fetch()

  index: ->
    viewButton = new Weightyplates.Views.WorkoutEntryButton(collection: @collection)
    $('.add-workout-button-area').html(viewButton.render().el)








