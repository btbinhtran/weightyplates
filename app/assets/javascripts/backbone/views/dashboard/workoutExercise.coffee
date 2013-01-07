class Weightyplates.Views.WorkoutExercise extends Backbone.View

  template: JST['dashboard/workout_entry_exercise']

  el: '.workout-entry-exercise-and-sets-row'

  events:
    'click .add-workout-exercise-add-button': 'addExercise'
    'click .add-workout-exercise-remove-button': 'removeExercise'

  initialize: ()->
    exerciseCount = @model.get "exerciseCount"
    exercisePhrase = "Exercise #{exerciseCount}"

    if @model.get("anOptionListFilled") == false
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

    #$('#workout-form-container .add-workout-exercise-drop-downlist').html(optionsList)
      @model.set("anOptionListFilled", true)


    @render(exercisePhrase, exerciseCount, optionsList)

  render: (exercisePhrase, exerciseCount, optionsList)->
    $rowContent = @$el.html()
    $newContent = $rowContent + @template()
    @$el.html($newContent)
    @$el.find('.add-workout-exercise-label').last().text(exercisePhrase)


    console.log "exercise count "
    console.log exerciseCount
    if @model.get("anOptionListFilled") == true && exerciseCount >= 2
      console.log "list got filled before"
      console.log @$el
      copyOfOptionListEntries = @$el.children().first().find('.add-workout-exercise-drop-downlist').html()
      console.log @$el.children().prev().last().find('.add-workout-exercise-drop-downlist').html(copyOfOptionListEntries)
    else
      @$el.find('.add-workout-exercise-drop-downlist').html(optionsList)
    @model.set("exerciseCount", exerciseCount + 1)
    this

  addExercise: (event)->
    event.preventDefault()
    #condition is needed to prevent double creation of exercise
    if  $(event.target).is(":visible") == true
      viewExerciseEntry = new Weightyplates.Views.WorkoutExercise(model: @model, addingExercise: "addExercise")

  removeExercise: (event)->
