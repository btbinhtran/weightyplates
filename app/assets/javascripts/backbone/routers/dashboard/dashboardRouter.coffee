class Weightyplates.Routers.Dashboard extends Backbone.Router
  routes:
    '': 'index'

  initialize: ->


  index: ->
    viewButton = new Weightyplates.Views.WorkoutEntryButton()

    $('.add-workout-button-area').html(viewButton.render().el)






