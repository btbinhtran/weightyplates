class Weightyplates.Routers.Dashboard extends Backbone.Router
  routes:
    '': 'index'

  initialize: ->
    @collection = new Weightyplates.Collections.DashboardItems()

    @collection.reset(Weightyplates.PreloadModels)

  index: ->
    addWorkoutView = new Weightyplates.Views.WorkoutForm(model: @collection.models[0])
    #viewButton = new Weightyplates.Views.WorkoutEntryButton(collection: @collection)
    #$('.add-workout-button-area').html(viewButton.render().el)








