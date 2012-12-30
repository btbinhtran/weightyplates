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

    $.ajax
      type: "POST"
      url: "/api/workouts"
      dataType: "JSON"
      data:
        "workout":
          "unit": "kg"
          "name": "a name"
          "workout_entry":
            "exercise_id": 1
            "workout_id": null



      success: () ->
        console.log "successful post"

      error:(jqXHR, textStatus, errorThrown) ->
        console.log(
          "The following error occured: "+
          textStatus, errorThrown
        )



