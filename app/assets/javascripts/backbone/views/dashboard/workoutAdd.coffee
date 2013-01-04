class Weightyplates.Views.WorkoutEntryButton extends Backbone.View

  template: JST['dashboard/workout_entry_button']

  events:
    'click #add-workout': 'addWorkoutFormState'

  initialize: ->

  render: ->
    $(@el).html(@template())
    this

  addWorkoutFormState: (event) ->
    if @collection.models[0].get("showingWorkoutForm") == true
      event.preventDefault()
    else if @collection.models[0].get("showingWorkoutForm") == false && @collection.models[0].get("hidingWorkoutForm") == false
      event.target.blur()
      @loadWorkoutForm()
    else if @collection.models[0].get("hidingWorkoutForm") == true
      @collection.models[0].set("showingWorkoutForm", false)
      @collection.models[0].set("hidingWorkoutForm", false)
      $('.dashboard-add-workout-modal-row')
        .addClass("dashboard-add-workout-modal-row-show")
        .removeClass("dashboard-add-workout-modal-row")

  loadWorkoutForm: () ->
    addWorkoutView = new Weightyplates.Views.workoutForm(model: @collection.models[0])
    @collection.models[0].set("showingWorkoutForm", true)
    @modelOfExercises = new Weightyplates.Models.ListOfExercises(model: gon.exercises)
    @theListOfExercisesLoaded()

  theListOfExercisesLoaded: ->
    console.log "adding"
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

    $('#workout-form-container .add-workout-exercise-drop-downlist').html(optionsList)






