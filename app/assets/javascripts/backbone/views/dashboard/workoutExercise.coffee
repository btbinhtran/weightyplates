class Weightyplates.Views.WorkoutExercise extends Backbone.View

  template: JST['dashboard/workout_entry_exercise']

  events:
    'click .add-workout-exercise-add-button': 'addExercise'
    'click .add-workout-exercise-remove-button': 'removeExercise'
    'click .add-workout-reps-remove-button': 'removeDetails'

  initialize: ()->
    exerciseCount = @model.get "exerciseCount"
    #need to add one for starting at a zero index
    exercisePhrase = "Exercise #{exerciseCount + 1}"

    if @model.get("isOneOptionListFilled") == false
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
      @model.set("isOneOptionListFilled", true)
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

    @$el.parent().addClass("#{@cid}")
    #add the option entries into the dropdown and remove the id so new entries can be referenced

    $workoutRowFound.find('.add-workout-exercise-drop-downlist').html(optionsList)
    $('#an-Exercise-label').text(exercisePhrase).removeAttr("id")

    #removing reference of id for the entry details
    $exerciseDetail = @$el.parent().nextAll(".row-fluid").first().find('#an-entries-details').addClass("recentlyAdded").removeAttr("id").addClass("#{@cid}")

    $exerciseDetailParent = $exerciseDetail.parent().addClass("#{@cid}")

    #define the el element because it is empty
    @el = @$el[0]

    #keep track of the view exercises being added
    exerciseViews = @model.get("exerciseViews")
    exerciseViews.push({viewExercise:@, viewDetails: $exerciseDetailParent})
    @model.set("exerciseViews", exerciseViews)

    #make all references of 'this' to reference the main object
    _.bindAll(@)

    #return this
    this

  addExercise: (event)->
    #generate a new exercise entry
    viewExerciseEntry = new Weightyplates.Views.WorkoutExercise(model: @model)

  removeExercise: (event)->
    if @model.get("exerciseCount") > 1
      #console.log @
      #console.log @model.get("exerciseViews")
      #@stopListening()
      #$parentElement = @$el.parent().parent()
      #@remove()

    else
     alert "A workout must have at least one exercise."

  removeDetails: ->
    console.log "deleting"
