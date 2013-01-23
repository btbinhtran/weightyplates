class Weightyplates.Models.FormAndExercises extends Backbone.Model

  #validate: (attrs,  options) ->

  prepareEntries: ->
    @modelOfExercises = new Weightyplates.Models.ListOfExercises(model: gon.exercises)
    theExerciseModel = @modelOfExercises.attributes.model
    theExerciseModelLength = theExerciseModel.length
    entry = 0
    optionsList = []
    optionsList.push("<option></option>")
    while entry < theExerciseModelLength
      theEntry = theExerciseModel[entry]
      dataIdAttribute = "data-id='#{(theEntry.id)}'"
      dataEquipmentAttribute = "data-equipment='#{theEntry.equipment}'"
      dataForceAttribute = "data-force='#{theEntry.force}'"
      dataIsSportAttribute = "data-isSport='#{theEntry.is_sport}'"
      dataLevelAttribute = "data-level='#{theEntry.level})'"
      dataMechanicsAttribute = "data-mechanics='#{theEntry.mechanics}'"
      dataMuscleAttribute = "data-muscle='#{theEntry.muscle}'"
      dataTypeAttribute = "data-type='#{theEntry.type}'"
      exerciseName = theEntry.name
      exerciseName = exerciseName.replace(/'/g, '&#039;')
      valueAttribute = "value='" + exerciseName + "'"
      optionEntry = "<option " + dataIdAttribute + dataEquipmentAttribute + dataForceAttribute + dataIsSportAttribute + dataLevelAttribute + dataMechanicsAttribute + dataMuscleAttribute + dataTypeAttribute  + valueAttribute + ">" + exerciseName + "</option>"
      optionsList.push(optionEntry)
      entry++
    optionListEntries = optionsList


  defaults:
    workoutNameHint: "Optional (defaults to timestamp)"
    exerciseCount: 0
    isFirstExerciseRow: false
    optionListEntries: null
    exerciseViews: []
    exerciseViewsCount: null
    firstExercise: null
    lastExercise: null
    hiddenExerciseRemoveButton: null
    recentlyAddedExerciseAssociatedModel: null
    recentlyRemovedExerciseAssociatedModel: null
    signalParentForm: -1
    exerciseAssociatedModels: []



