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
      @model.set("firstExercise", @)
    else
      #reference the data from the model that was stored the first time
      optionsList = @model.get("optionListEntries")
      @model.set("lastExercise", @)

    #increment the exercise count for the exercise label
    @model.set("exerciseCount", exerciseCount + 1)

    #render the template
    @render(exercisePhrase, optionsList)

  render: (exercisePhrase, optionsList)->

    #the main exercise row
    $workoutExeciseMainRow = $('.workout-entry-exercise-and-sets-row')

    #append template because there will be further exercise entries
    $workoutExeciseMainRow.append(@template())

    #find the recently added exercise entry from the template append
    $workoutRowFound = $workoutExeciseMainRow.find('#exercise-grouping')

    #define the @$el element because it is empty
    @$el = $workoutRowFound.removeAttr("id")

    #define the el element because it is empty
    @el = @$el[0]

    #remove the id from entry details; subsequent entries will have the same id
    $workoutRowFound.find('#an-entries-details').removeAttr("id")

    #add the option list entries
    $workoutRowFound.find('.add-workout-exercise-drop-downlist').html(optionsList)

    #add the number label for the exercise; remove id because subsequent entries will have the same id
    $('#an-Exercise-label').text(exercisePhrase).removeAttr("id")

    ###
    #keep track of the view exercises being added
    exerciseViews = @model.get("exerciseViews")
    exerciseViews.push({viewExercise:@, viewDetails: $exerciseDetailParent})
    @model.set("exerciseViews", exerciseViews)
    ###

    #make all references of 'this' to reference the main object
    _.bindAll(@)

    #return this
    this

  addExercise: (event)->
    #generate a new exercise entry
    viewExerciseEntry = new Weightyplates.Views.WorkoutExercise(model: @model)

  removeExercise: (event)->
    if @model.get("exerciseCount") > 1

      notTheLast = (@model.get("lastExercise").cid != @cid)

      #if not last entry, then the first and middle entries will need to save ref
      if notTheLast
        #the first or middle entry
          $siblings = @$el.nextAll()

      #remove view and event listeners attached to it; event handlers first
      @stopListening()
      @remove()

      #decrementing the exercise labels when deleting exercise entries
      if notTheLast
        $siblingExerciseLabels = $siblings.find('.add-workout-exercise-label')
        $siblingExerciseLabels.each ->
          oldNumber = parseInt($(this).text().replace(/Exercise /g, ''))
          $(this).text("Exercise #{oldNumber - 1}")

      #decrement the exercise count
      @model.set("exerciseCount", @model.get("exerciseCount") - 1)

    else
     alert "A workout must have at least one exercise."

  removeDetails: ->
    console.log "deleting"
