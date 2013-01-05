class Weightyplates.Views.WorkoutExercise extends Backbone.View

  template: JST['dashboard/workout_entry_exercise']

  initialize: ->
    @$el.html(@template())

  render: ->
    this
