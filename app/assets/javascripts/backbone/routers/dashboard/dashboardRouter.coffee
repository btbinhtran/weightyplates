class Weightyplates.Routers.Dashboard extends Backbone.Router
  routes:
    '': 'index'

  initialize: ->
    @model = new Weightyplates.Models.DashboardState
    @model.fetch()


  index: ->
    viewButton = new Weightyplates.Views.WorkoutEntryButton(model: @model)
    $('.add-workout-button-area').html(viewButton.render().el)








