class Weightyplates.Views.WorkoutEntryButton extends Backbone.View

  template: JST['dashboard/workout_entry_button']

  events:
    'click #add-workout': 'addWorkoutFormState'

  initialize: ->

  render: ->
    $(@el).html(@template())
    this

  addWorkoutFormState: (event) ->
    console.log @collection
    console.log @collection.models[0]
    console.log @collection.models[0].get "onIndexDashboard"

    #console.log @model.get "addWorkoutForm"



  loadWorkoutForm: (event) ->
    addWorkoutView = new Weightyplates.Views.workoutForm(model: @model)

    @model.defaults.appState[0].addWorkoutForm = true
    appStateForm = @model.defaults.appState[0].addWorkoutForm



    event.target.blur()

    $(".dashboard-add-workout-modal-row")
      .addClass("dashboard-add-workout-modal-row-show row-fluid")
      .removeClass "dashboard-add-workout-modal-row"


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






