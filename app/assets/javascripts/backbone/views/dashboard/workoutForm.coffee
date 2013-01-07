class Weightyplates.Views.WorkoutForm extends Backbone.View

  template: JST['dashboard/workout_form']

  el: '#workout-form-container'

  events:
    'click #last-row-save-button': 'saveWorkout'
    'focus input.dashboard-workout-name-input': 'focusInWorkoutName'
    'blur input.dashboard-workout-name-input': 'blurInWorkoutName'
    'click #workout-form-main-close-button': 'closeAddWorkoutDialog'

  initialize: ->
    _.bindAll(this)
    @modelWorkoutFormState = new Weightyplates.Models.WorkoutFormState()
    @modelWorkoutFormInputs = new Weightyplates.Models.WorkoutFormInputs
    @modelWorkoutFormState.on('change:attemptExerciseCreation', @createExercise)
    @render()

  render: ()->
    @$el.html(@template())
    viewExerciseEntry = new Weightyplates.Views.WorkoutExercise(model: @modelWorkoutFormState)
    #$('.workout-entry-exercise-and-sets-row').append(viewExerciseEntry.render().el)

    $(document).on('keypress', this.closeAddWorkoutDialog)
    @hintInWorkoutName()
    this

  getEventTarget: (event)->
    $(event.target)

  focusInWorkoutName: (event) ->
    $this = @getEventTarget(event)
    $this.val("").removeClass("hint") if $this.attr('class') == "dashboard-workout-name-input hint"

  blurInWorkoutName: (event) ->
    $this = @getEventTarget(event)
    $this.val(@modelWorkoutFormState.get "workoutNameHint").addClass "hint" if $this.val().length == 0

  hintInWorkoutName: ->
    $workoutNameInput = $('input.dashboard-workout-name-input')
    $workoutNameInput.val(@modelWorkoutFormState.get "workoutNameHint").addClass('hint')

  closeAddWorkoutDialog: (event) ->
    if event.keyCode == 27 || event.type == "click"
      @model.set("showingWorkoutForm", false)
      @model.set("hidingWorkoutForm", true)
      $('.dashboard-add-workout-modal-row-show')
        .addClass("dashboard-add-workout-modal-row")
        .removeClass("dashboard-add-workout-modal-row-show")

  createExercise: ->
    console.log "attempt create"
    #console.log @modelWorkoutFormState
    viewExerciseEntry = new Weightyplates.Views.WorkoutExercise()
    $('.workout-entry-exercise-and-sets-row').append(viewExerciseEntry.render().el)

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
                $inputWorkoutName = $("input.dashboard-workout-name-input")
                if $inputWorkoutName.length && $inputWorkoutName.not(".hint") > 0
                  $inputWorkoutName.val()
                else if $inputWorkoutName.hasClass('hint')
                  new Date()
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



