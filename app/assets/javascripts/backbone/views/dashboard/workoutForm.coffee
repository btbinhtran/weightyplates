class Weightyplates.Views.workoutForm extends Backbone.View

  template: JST['dashboard/workout_form']

  el: '#workout-form-container'

  events:
    'click #last-row-save-button': 'saveWorkout'
    'click #collapse-button': 'hideAddWorkoutDialog'

  initialize: ->
    @$el.html(@template())


  render: ->

    this



  hintInWorkoutName: ->
    $workoutNameInput = $('input.dashboard-workout-name-input')
    workoutNameHint = "Optional (defaults to timestamp)"

    $workoutNameInput.val(workoutNameHint).addClass('hint').on("focus", ->
      $(this).val("").removeClass("hint") if $(this).attr('class') == "dashboard-workout-name-input hint"
    ).on("blur",->
      $(this).val(workoutNameHint).addClass "hint" if $(this).val().length == 0
    )

  hideAddWorkoutDialog: ->
    console.log "clicking"
    $('.dashboard-add-workout-modal-row-show')
      .addClass("dashboard-add-workout-modal-row")
      .removeClass("dashboard-add-workout-modal-row-show")
    console.log appStateForm
    #appStateForm = false

  saveWorkout: ->
    $.ajax
      type: "POST"
      url: "/api/workouts"
      dataType: "JSON"
      data:
        "workout":
          {
            "unit": $('.add-workout-units').text()
            "name":
              (->
                if $("input.dashboard-workout-name-input hint").length is 0
                  new Date()
                else
                  $("input.dashboard-workout-name-input").val()
              )()
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



