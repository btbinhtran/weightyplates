class Weightyplates.Views.workoutForm extends Backbone.View

  template: JST['dashboard/workout_form']

  el: '#workout-form-container'

  events:
    'click #last-row-save-button': 'saveWorkout'

  initialize: ->
    @model = new Weightyplates.Models.Exercises()
    @$el.html(@template(model: @model))

  render: ->
    this

  saveWorkout: ->
    #console.log(@collection.create name: "a name")
    #@model.save()
    data = @model
    signForm = $.ajax(
      type: "POST"
      url: "/api/workouts.json"
      dataType: "JSON"
      #data: data
    )



