class Weightyplates.Views.WorkoutExercise extends Backbone.View

  template: JST['dashboard/workout_entry_exercise']

  tagName: "div"

  className: "row-fluid"

  initialize: ->
    @render()

  render: ->
    @$el.html(@template())
    this
