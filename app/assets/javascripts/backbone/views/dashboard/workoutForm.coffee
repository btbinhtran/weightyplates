class Weightyplates.Views.WorkoutForm extends Backbone.View

  template: JST['dashboard/workout_form']

  el: '#workout-form-container'

  events:
    'click #last-row-save-button': 'validateBeforeSave'
    'focus input.dashboard-workout-name-input': 'focusInWorkoutName'
    'blur input.dashboard-workout-name-input': 'blurInWorkoutName'
    'click #workout-form-main-close-button': 'closeAddWorkoutDialog'
    'click #last-row-note-button': 'addNote'

  initialize: ->
    #make all references of 'this' to reference the main object
    _.bindAll(@)

    #model for workout state
    @modelFormAndExercises = new Weightyplates.Models.FormAndExercises()

    #prepare the option entries
    @modelFormAndExercises.set("optionListEntries", @modelFormAndExercises.prepareEntries())

    #create an associated user model for workouts and further nesting of associated models
    @associatedModelUser = new Weightyplates.Models.AssociationUserSession()
    @associatedWorkout = new Weightyplates.Models.AssociationWorkout()
    @associatedModelUser.set({workout: [@associatedWorkout]})


    #console.log "user session"
    #console.log @associatedModelUser

    @modelFormAndExercises.on("change:signalParentForm", @updateAssociatedModel)

    #call render
    @render()

  render: ()->
    #load the view template
    @$el.html(@template())

    #form view gets the FormAndExercises model
    new Weightyplates.Views.WorkoutExercise(model: @modelFormAndExercises)

    #$(document).on('keypress', @closeAddWorkoutDialog)
    @hintInWorkoutName()
    this

  updateAssociatedModel: ->
    console.log "updating associated models"

    #add and removal check for entries
    if @associatedWorkout.get("workout_entry")
      #remove if there is already and entry
      if @associatedWorkout.get("workout_entry").get(@modelFormAndExercises.get("recentlyRemovedExerciseAssociatedModel"))
        @associatedWorkout.get("workout_entry").remove(@modelFormAndExercises.get("recentlyRemovedExerciseAssociatedModel"))
       else
        #add instead of overwriting if there already a workout entry
        @associatedWorkout.get("workout_entry").add(@modelFormAndExercises.get("recentlyAddedExerciseAssociatedModel"))

    else
      @associatedWorkout.set({workout_entry: [@modelFormAndExercises.get "recentlyAddedExerciseAssociatedModel"]})


    #console.log JSON.stringify(@associatedModelUser)

  getEventTarget: (event)->
    $(event.target)

  focusInWorkoutName: (event) ->
    $this = @getEventTarget(event)
    $this.val("").removeClass("hint") if $this.attr('class') == "dashboard-workout-name-input hint"

  blurInWorkoutName: (event) ->
    $this = @getEventTarget(event)
    $this.val(@modelFormAndExercises.get "workoutNameHint").addClass "hint" if $this.val().length == 0

  hintInWorkoutName: ->
    $workoutNameInput = $('input.dashboard-workout-name-input')
    $workoutNameInput.val(@modelFormAndExercises.get "workoutNameHint").addClass('hint')

  closeAddWorkoutDialog: (event) ->

    #console.log @modelFormAndExercises.get("atLeastOneFieldFilled")

    theCaller = "closeAddWorkoutDialog"

    @validateBeforeSave(theCaller)


    if @modelFormAndExercises.get("atLeastOneFieldFilled") == true
      if (confirm "Changes have been made to the form, do you want to close now?")
        console.log "click ok"
      else
        console.log "not ok"

    #console.log $('.add-workout-reps-input')

    #@modelFormAndExercises.set("age", $('.add-workout-reps-input').val())
    #console.log @modelFormAndExercises.get "age"
    #console.log  _.size(@modelFormAndExercises.get("exerciseViews"))

    ###
    if event.keyCode == 27 || event.type == "click"
      @model.set("showingWorkoutForm", false)
      @model.set("hidingWorkoutForm", true)
      $('.dashboard-add-workout-modal-row-show')
        .addClass("dashboard-add-workout-modal-row")
        .removeClass("dashboard-add-workout-modal-row-show")
    ###

  addNote: ->
    console.log JSON.stringify(@associatedModelUser)

  validateBeforeSave: (theCaller)->
    associatedModels = @associatedModelUser.get("workout[0]").get("workout_entry")
    workoutEntryLength = associatedModels.length

    i = 0

    missingExerciseFieldCount = 0
    missingDetailFieldCount = 0
    dateInExerciseFieldCount = 0
    dateInDetailFieldCount = 0

    while i <= workoutEntryLength - 1
      evalifNull = associatedModels.at(i).get("exercise_id")

      #check for presence of inputs
      if !_.isNull(evalifNull) and !_.isUndefined(evalifNull)
        ++dateInExerciseFieldCount

      #console.log "exercise input count is "
      #console.log dateInExerciseFieldCount

      #checking for presence of null, which means there was no input
      if _.isNull(evalifNull) and !_.isUndefined(evalifNull)
        missingExerciseFieldCount++

        #console.log 'gone to one exercise'

      #console.log "entry details is"
      #console.log associatedModels.at(i).get("entry_detail")
      entryDetailLength = associatedModels.at(i).get("entry_detail").length

      #console.log "j is"
      entryDetailModel = associatedModels.at(i).get("entry_detail")

      j = 0

      #console.log 'j is' + j
      #console.log "entrydetail length is " + entryDetailLength

      while j <= entryDetailLength - 1

       # console.log "detailing------------------------------------------"

        evalWeightNull = entryDetailModel.at(j).get("weight")
        evalRepNull = entryDetailModel.at(j).get("reps")

        #checking for presence of null, meaning not input
        if _.isNull(evalWeightNull) and !_.isUndefined(evalWeightNull)
          missingDetailFieldCount++
        if _.isNull(evalRepNull) and !_.isUndefined(evalRepNull)
          missingDetailFieldCount++



        if !_.isNull(evalWeightNull) and !_.isUndefined(evalWeightNull) and evalWeightNull != ""
          ++dateInDetailFieldCount

        if !_.isNull(evalRepNull) and !_.isUndefined(evalRepNull) and evalRepNull != ""
          ++dateInDetailFieldCount

        #console.log "details input count is "
        #console.log dateInDetailFieldCount



        j++

      i++
    #console.log "missing field"

    #console.log "filled fields are "
    totalFilledFields = dateInDetailFieldCount + dateInExerciseFieldCount


    if(dateInDetailFieldCount + dateInExerciseFieldCount) > 0
      @modelFormAndExercises.set("atLeastOneFieldFilled", true)
    else
      @modelFormAndExercises.set("atLeastOneFieldFilled", false)

    #console.log @modelFormAndExercises.get("atLeastOneFieldFilled")

    #console.log "missing detail count is "
    #console.log missingDetailFieldCount

    #console.log "exercise error count is"
    #console.log missingExerciseFieldCount

    totalFieldErrors = missingDetailFieldCount + missingExerciseFieldCount

    totalFilledFields

    if theCaller == "closeAddWorkoutDialog"
      totalFilledFields
    else
      @saveWorkout(totalFieldErrors)


  saveWorkout: (totalFieldErrors)->

    #console.log

    if totalFieldErrors > 0
      #console.log "Can not be save because of missing fields."
      #console.log totalFieldErrors
      alert "Please fill missing fields before submitting."
    #console.log "-------------------------------------"






    jsonData = JSON.stringify(@associatedModelUser)

    #formatting the jsonData by removing the first '[' and last ']'
    jsonDataLastRightBracketIndex = jsonData.lastIndexOf(']')

    rightBracketRemovedJson = jsonData.substring(0, jsonDataLastRightBracketIndex) + jsonData.substring(jsonDataLastRightBracketIndex + 1)

    properlyFormattedJson = rightBracketRemovedJson.replace("[", '')



    #console.log "clicking"

    console.log properlyFormattedJson

    ###
    $.ajax
      type: "POST"
      url: "/api/workouts"
      dataType: "JSON"
      contentType: 'application/json',
      data: properlyFormattedJson
      success: () ->

        #console.log @
      error: (jqXHR, textStatus, errorThrown) ->
        console.log(
          "The following error occurred: " +
          textStatus + errorThrown
        )
    ###



