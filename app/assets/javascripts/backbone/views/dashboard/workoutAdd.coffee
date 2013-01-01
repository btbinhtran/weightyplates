class Weightyplates.Views.WorkoutEntryButton extends Backbone.View

  template: JST['dashboard/workout_entry_button']

  events:
    'click #add-workout': 'addWorkoutFormState'

  initialize: ->

  render: ->
    $(@el).html(@template())
    this

  addWorkoutFormState: (event) ->

    if @model.defaults.appState[0].addWorkoutForm == true
      $('#add-workout').click (event)->
        event.preventDefault()
    else if @model.defaults.appState[0].addWorkoutForm == false
      @loadWorkoutForm(event)

  loadWorkoutForm: (event) ->
    @model.defaults.appState[0].addWorkoutForm = true
    appStateForm = @model.defaults.appState[0].addWorkoutForm

    addWorkoutView = new Weightyplates.Views.workoutForm()

    $("#add-workout").click ->
      @blur()
      $(".dashboard-add-workout-modal-row")
        .addClass("dashboard-add-workout-modal-row-show row-fluid")
        .removeClass "dashboard-add-workout-modal-row"

    hideAddWorkoutDialog = ->
      $('.dashboard-add-workout-modal-row-show')
        .addClass("dashboard-add-workout-modal-row")
        .removeClass("dashboard-add-workout-modal-row-show")

    $('#collapse-button').click ->
      hideAddWorkoutDialog()
      appStateForm = false

    $(document).on "keypress", (event) ->
        if event.keyCode == 27
          hideAddWorkoutDialog()
          appStateForm = false

    @modelOfExercises = new Weightyplates.Models.ListOfExercises(model: gon.exercises)

    @theListOfExercisesLoaded()

  theListOfExercisesLoaded: ->

    theExerciseModel = @modelOfExercises.attributes.model
    theExerciseModelLength = theExerciseModel.length

    entry = 0
    optionsList = []
    optionsList.push("<option></option>")

    while entry < theExerciseModelLength
      dataIdAttribute = "data-id='" + (theExerciseModel[entry].id) + "' "
      dataEquipmentAttribute = "data-equipment='" + (theExerciseModel[entry].equipment) + "' "
      dataForceAttribute = "data-force='" + (theExerciseModel[entry].force) + "' "
      dataIsSportAttribute = "data-isSport='" + (theExerciseModel[entry].is_sport) + "' "
      dataLevelAttribute = "data-level='" + (theExerciseModel[entry].level) + "' "
      dataMechanicsAttribute = "data-mechanics='" + (theExerciseModel[entry].mechanics) + "' "
      dataMuscleAttribute = "data-muscle='" + (theExerciseModel[entry].muscle) + "' "
      dataTypeAttribute = "data-type='" + (theExerciseModel[entry].type) + "' "
      exerciseName = theExerciseModel[entry].name
      exerciseName = exerciseName.replace(/'/g, '&#039;')
      valueAttribute = "value='" + exerciseName + "'"
      optionEntry = "<option " + dataIdAttribute + dataEquipmentAttribute + dataForceAttribute + dataIsSportAttribute + dataLevelAttribute + dataMechanicsAttribute + dataMuscleAttribute + dataTypeAttribute  + valueAttribute + ">" + exerciseName + "</option>"
      optionsList.push(optionEntry)
      entry++

    $('#workout-form-container').find('.add-workout-exercise-drop-downlist').html(optionsList)

    hideAddWorkoutDialog = ->
      $('.dashboard-add-workout-modal-row-show')
        .addClass("dashboard-add-workout-modal-row")
        .removeClass("dashboard-add-workout-modal-row-show")





