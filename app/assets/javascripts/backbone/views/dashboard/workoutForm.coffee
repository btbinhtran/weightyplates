class Weightyplates.Views.workoutForm extends Backbone.View

  template: JST['dashboard/workout_form']

  el: '#workout-form-container'

  events:
    'click #last-row-save-button': 'saveWorkout'

  initialize: ->
    @$el.html(@template())

  render: ->
    this

  saveWorkout: ->
    alert "save attempt"


