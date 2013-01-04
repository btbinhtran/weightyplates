class Weightyplates.Views.workoutForm extends Backbone.View

  template: JST['dashboard/workout_form']

  el: '#workout-form-container'

  events:
    'click #last-row-save-button': 'saveWorkout'
    'focus input.dashboard-workout-name-input': 'focusInWorkoutName'
    'blur input.dashboard-workout-name-input': 'blurInWorkoutName'

  initialize: ->
    @modelWorkoutFormState = new Weightyplates.Models.WorkoutFormState()
    @$el.html(@template())
    _.bindAll(this);
    $(document).on('keypress', this.hideAddWorkoutDialog);
    @hintInWorkoutName()

  render: ->
    this

  focusInWorkoutName: (event) ->
    eventTarget = event.target
    $this = $(eventTarget)
    $this.val("").removeClass("hint") if $this.attr('class') == "dashboard-workout-name-input hint"

  blurInWorkoutName: (event) ->
    eventTarget = event.target
    $this = $(eventTarget)
    $this.val(@modelWorkoutFormState.get "workoutNameHint").addClass "hint" if $this.val().length == 0

  hintInWorkoutName: ->
    $workoutNameInput = $('input.dashboard-workout-name-input')
    $workoutNameInput.val(@modelWorkoutFormState.get "workoutNameHint").addClass('hint')

  hideAddWorkoutDialog: (event) ->
    if event.keyCode == 27
      @model.set("showingWorkoutForm", false)
      $('.dashboard-add-workout-modal-row-show')
        .addClass("dashboard-add-workout-modal-row")
        .removeClass("dashboard-add-workout-modal-row-show")

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



