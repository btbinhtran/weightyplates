class Weightyplates.Views.workoutForm extends Backbone.View

  template: JST['dashboard/workout_form']

  initialize: ->
    $('#container').html(@template())

  render: ->
    this