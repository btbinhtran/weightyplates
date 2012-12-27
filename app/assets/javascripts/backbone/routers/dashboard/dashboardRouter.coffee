class Weightyplates.Routers.Dashboard extends Backbone.Router
  routes:
    '': 'index'

  initialize: ->
    @collection = new Weightyplates.Models.Exercises()
    @collection.fetch(
      success:  _.bind(->
        console.log(@collection.workouts)
      , this)
    )

  index: ->
    viewButton = new Weightyplates.Views.WorkoutEntryButton()

    $('.add-workout-button-area').html(viewButton.render().el)






