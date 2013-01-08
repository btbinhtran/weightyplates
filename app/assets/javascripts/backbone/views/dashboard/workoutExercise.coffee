class Weightyplates.Views.WorkoutExercise extends Backbone.View

  template: JST['dashboard/workout_entry_exercise']

  events:
    'click .add-workout-exercise-add-button': 'addExercise'
    'click .add-workout-exercise-remove-button': 'removeExercise'

  initialize: ()->
    exerciseCount = @model.get "exerciseCount"
    exercisePhrase = "Exercise #{exerciseCount}"


    if @model.get("anOptionListFilled") == false
      console.log "should only run once"
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
      @model.set("anOptionListFilled", true)
      @model.set("optionListEntries", optionListEntries)
    else
      #reference the data from the model that was stored the first time
      optionsList = @model.get("optionListEntries")

    #increment the exercise count for the exercise label
    @model.set("exerciseCount", exerciseCount + 1)

    #render the template
    @render(exercisePhrase, optionsList)

  render: (exercisePhrase, optionsList)->
    #the main exercise row
    $workoutExeciseMainRow = $('.workout-entry-exercise-and-sets-row')
    #append template because there will be further exercise entries
    $workoutExeciseMainRow.append(@template())
    #going into the exercise dropdown row
    $workoutRowFound = $workoutExeciseMainRow.find('#an-exercise-row')
    #define the @$el element because it is empty
    @$el = $workoutRowFound.addClass("recentlyAdded").removeAttr("id")
    #add the option entries into the dropdown and remove the id so new entries can be referenced
    $workoutRowFound.find('.add-workout-exercise-drop-downlist').html(optionsList)
    $('#an-Exercise-label').text(exercisePhrase).removeAttr("id")
    #removing reference of id for the entry details
    @$el.parent().nextAll(".row-fluid").first().find('#an-entries-details').addClass("recentlyAdded").removeAttr("id")
    #define the el element because it is empty
    @el = @$el[0]
    #make all references of 'this' to reference the main object
    _.bindAll(@)
    #return this
    this

  addExercise: (event)->
    #generate a new exercise entry
    viewExerciseEntry = new Weightyplates.Views.WorkoutExercise(model: @model)

  removeExercise: (event)->
