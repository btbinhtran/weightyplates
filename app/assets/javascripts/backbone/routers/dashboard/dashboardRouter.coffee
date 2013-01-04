class Weightyplates.Routers.Dashboard extends Backbone.Router
  routes:
    '': 'index'

  initialize: ->

    bunchOfModels = []
    bunchOfModels.push(dashboardState = new Weightyplates.Models.DashboardState())
    bunchOfModels.push(workoutFormInputs = new Weightyplates.Models.WorkoutFormInputs())

    @collection = new Weightyplates.Collections.DashboardItems(bunchOfModels)


    @collection.fetch()

  index: ->
    viewButton = new Weightyplates.Views.WorkoutEntryButton(collection: @collection)
    $('.add-workout-button-area').html(viewButton.render().el)








