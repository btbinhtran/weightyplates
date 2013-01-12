class Weightyplates.Views.WorkoutForm extends Backbone.View

  template: JST['dashboard/workout_form']

  el: '#workout-form-container'

  events:
    'click #last-row-save-button': 'saveWorkout'
    'focus input.dashboard-workout-name-input': 'focusInWorkoutName'
    'blur input.dashboard-workout-name-input': 'blurInWorkoutName'
    'click #workout-form-main-close-button': 'closeAddWorkoutDialog'

  initialize: ->
    _.bindAll(@)
    @modelWorkoutFormState = new Weightyplates.Models.WorkoutFormState()
    @modelWorkoutFormInputs = new Weightyplates.Models.WorkoutFormInputs
    @render()

  render: ()->
    @$el.html(@template())

    @modelOfExercises = new Weightyplates.Models.ListOfExercises(model: gon.exercises)
    theExerciseModel = @modelOfExercises.attributes.model
    theExerciseModelLength = theExerciseModel.length
    entry = 0
    optionsList = []
    optionsList.push("<option></option>")
    while entry < theExerciseModelLength
      theEntry = theExerciseModel[entry]
      dataIdAttribute = "data-id='" + (theEntry.id) + "' "
      dataEquipmentAttribute = "data-equipment='" + (theEntry.equipment) + "' "
      dataForceAttribute = "data-force='" + (theEntry.force) + "' "
      dataIsSportAttribute = "data-isSport='" + (theEntry.is_sport) + "' "
      dataLevelAttribute = "data-level='" + (theEntry.level) + "' "
      dataMechanicsAttribute = "data-mechanics='" + (theEntry.mechanics) + "' "
      dataMuscleAttribute = "data-muscle='" + (theEntry.muscle) + "' "
      dataTypeAttribute = "data-type='" + (theEntry.type) + "' "
      exerciseName = theEntry.name
      exerciseName = exerciseName.replace(/'/g, '&#039;')
      valueAttribute = "value='" + exerciseName + "'"
      optionEntry = "<option " + dataIdAttribute + dataEquipmentAttribute + dataForceAttribute + dataIsSportAttribute + dataLevelAttribute + dataMechanicsAttribute + dataMuscleAttribute + dataTypeAttribute  + valueAttribute + ">" + exerciseName + "</option>"
      optionsList.push(optionEntry)
      entry++
    optionListEntries = optionsList
    @modelWorkoutFormState.set("optionListEntries", optionListEntries)

    viewExerciseEntry = new Weightyplates.Views.WorkoutExercise(model: @modelWorkoutFormState)
    $(document).on('keypress', @closeAddWorkoutDialog)
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

  saveWorkout: ->
    $.ajax
      type: "POST"
      url: "/api/workouts"
      dataType: "JSON"
      data:
        "workout":
          {
          "unit": $('.add-workout-units').text()
          "name": (->
            $inputWorkoutName = $("input.dashboard-workout-name-input")
            if $inputWorkoutName.length && $inputWorkoutName.not(".hint") > 0
              $inputWorkoutName.val()
            else if $inputWorkoutName.hasClass('hint')
              new Date()
          )()
          "workout_entry": [
            {
            "exercise_id": $('.add-workout-exercise-drop-downlist').find(':selected').data('id')
            "entry_detail": [
              {
              "weight": $('.add-workout-exercise-entry-input').val()
              "reps": $('.add-workout-reps-input').val()
              "set_number": $('.add-workout-set-label').text().replace(/S/g, '') * 1
              },
              {
              "weight": $('.add-workout-exercise-entry-input').val()
              "reps": $('.add-workout-reps-input').val()
              "set_number": $('.add-workout-set-label').text().replace(/S/g, '') * 1
              }

            ]
            },
            {
            "exercise_id": $('.add-workout-exercise-drop-downlist').find(':selected').data('id')
            "entry_detail": [
              {
              "weight": $('.add-workout-exercise-entry-input').val()
              "reps": $('.add-workout-reps-input').val()
              "set_number": $('.add-workout-set-label').text().replace(/S/g, '') * 1
              }

            ]
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



