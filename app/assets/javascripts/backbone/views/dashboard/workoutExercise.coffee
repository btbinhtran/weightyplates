class Weightyplates.Views.WorkoutExercise extends Backbone.View

  template: JST['dashboard/workout_entry_exercise']

  events:
    'click .add-workout-exercise-add-button': 'addExercise'
    'click .add-workout-exercise-remove-button': 'removeExercise'


  initialize: ()->


    #exerciseCount = @model.get "exerciseCount"
    #exercisePhrase = "Exercise #{exerciseCount}"

    ###
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


    #$('#workout-form-container .add-workout-exercise-drop-downlist').html(optionsList)
      @model.set("anOptionListFilled", true)
     ###

    #@render(exercisePhrase, exerciseCount)
    #$rowContent = @$el.html()
    #$newContent = $rowContent + @template()
    #console.log @template().find('#an-Exercise-label')
    #@$el.html($newContent)
    @render()

  render: ()->

    console.log "rendering"
    $workoutExeciseMainRow = $('.workout-entry-exercise-and-sets-row')

    $workoutExeciseMainRow.append(@template())
    #$toBeLabelExercise = @$el.find('#an-Exercise-label')
    #$toBeLabelExercise.text(exercisePhrase)
    #$toBeLabelExercise.attr("id", "")

    #@$el.children().last().find('.add-workout-exercise-label').text(exercisePhrase)

    ###
    console.log "exercise count"
    console.log exerciseCount
    if @model.get("anOptionListFilled") == true && exerciseCount >= 2
      console.log "list got filled before"

      @$el.children().prev().last().find('.add-workout-exercise-drop-downlist').html(@model.get "optionListEntries")
    else
      console.log "first time"
      $listWithEntries = @$el.find('.add-workout-exercise-drop-downlist')
      $listWithEntries.attr("id", "firstOptionList")
      $listWithEntries.html(optionsList)
      @model.set("optionListEntries", optionsList)

    ###
    #@model.set("exerciseCount", exerciseCount + 1)
    #console.log "exerciseCount is "
    #console.log @model.get("exerciseCount")

    @$el = $workoutExeciseMainRow.find('#an-exercise-row').addClass("recentlyAdded").removeAttr("id")
    #console.log $('.workout-entry-exercise-and-sets-row').find('.dashboard-add-workout-exercise')
    @$el.parent().nextAll(".row-fluid").first().find('#an-entries-details').addClass("recentlyAdded").removeAttr("id")
    @el = @$el[0]

    _.bindAll(this)
    this

  addExercise: (event)->
    console.log "click"

    viewExerciseEntry = new Weightyplates.Views.WorkoutExercise()

  removeExercise: (event)->
