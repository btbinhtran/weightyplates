class Weightyplates.Views.workoutForm extends Backbone.View

  template: JST['dashboard/workout_form']

  el: '#workout-form-container'

  events:
    'click #last-row-save-button': 'saveWorkout'

  initialize: ->
    @$el.html(@template())

    $workoutNameInput = $('input.dashboard-workout-name-input')
    workoutNameHint = "Optional (defaults to timestamp)"

    $workoutNameInput.val(workoutNameHint).addClass('hint').on("focus", ->
      $(this).val("").removeClass("hint") if $(this).attr('class') == "dashboard-workout-name-input hint"
    ).on("blur",->
      $(this).val(workoutNameHint).addClass "hint" if $(this).val().length == 0
    )

  render: ->
    this

  saveWorkout: ->
    $.ajax
      type: "POST"
      url: "/api/workouts"
      dataType: "JSON"
      data:
        "workout":
          {
            "unit": $('.add-workout-units').text()
            "name": $('input.dashboard-workout-name-input').val() || new Date()
            "workout_entry":
              [
                {
                  "exercise_id": $('.add-workout-exercise-drop-downlist').find(':selected').data('id')
                }

              ]
          }






      success: () ->
        console.log "successful post"

      error: (jqXHR, textStatus, errorThrown) ->
        console.log(
          "The following error occurred: " +
          textStatus + errorThrown
        )



