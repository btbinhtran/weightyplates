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
          "unit": $('.add-workout-units').text()
          "name": $('.dashboard-workout-name-input').val() || new Date()
          "workout_entry":
            "exercise_id": $('.add-workout-exercise-drop-downlist').find(':selected').data('id')
            "workout_id": null



      success: () ->
        console.log "successful post"

      error:(jqXHR, textStatus, errorThrown) ->
        console.log(
          "The following error occured: " +
           textStatus + errorThrown
        )



