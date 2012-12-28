class Weightyplates.Views.workoutForm extends Backbone.View

  template: JST['dashboard/workout_form']

  el: '#workout-form-container'

  events:
    'click #last-row-save-button': 'saveWorkout'

  initialize: ->
    @model = new Weightyplates.Models.Exercises()
    @model.fetch()
    @model.on('reset', @$el.html(@template(model: @model)), this)

  render: ->
    this

  saveWorkout: ->
    data = @model
    console.log data.defaults
    $.ajax(
      type: "POST"
      url: "/api/workouts.json"
      dataType: "JSON"
      data: {"name": "A NAME", "unit": "kg"}
    )



