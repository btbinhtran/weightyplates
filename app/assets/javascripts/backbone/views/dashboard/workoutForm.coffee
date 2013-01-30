class Weightyplates.Views.WorkoutForm extends Backbone.View

  template: JST['dashboard/workout_form']

  el: '#workout-form-container'

  events:
    'click #last-row-save-button': 'validateBeforeSave'
    'mouseover #last-row-save-button': 'mouseOverSaveButton'
    'mouseout #last-row-save-button': 'mouseOutSaveButton'
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

    @modelFormAndExercises.on("change:signalParentForm", @updateAssociatedModel)

    #private form model to listen to events from child views
    @privateFormModel = new Weightyplates.Models.PrivateForm()

    #use backbone as a global event bus
    Backbone.on("lastInputFocused", (event) ->
      @privateFormModel.set("lastFocusedInputEvent", event)
    , @)

    Backbone.on("triggerSaveButtonClick", (event) ->
      @fromSaveButtonTrigger()
    , @)

    #call render
    @render()

  render: ()->
    #load the view template
    @$el.html(@template())

    #form view gets the FormAndExercises model
    exerciseView = new Weightyplates.Views.WorkoutExercise(model: @modelFormAndExercises)

    @hintInWorkoutName()
    this

  updateAssociatedModel: ->
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

  mouseOverSaveButton: ->
    #adding a class to the weight input
    if !_.isNull(@privateFormModel.get("lastFocusedInputEvent"))
      weightInputEvent = @privateFormModel.get("lastFocusedInputEvent")
      weightInputTarget = weightInputEvent.target
      newClassName = "#{weightInputTarget.className} + acknowledge-save-button"
      $(weightInputTarget).attr("class", newClassName)

  mouseOutSaveButton: ->
    #remove the added class for the weight input
    if !_.isNull(@privateFormModel.get("lastFocusedInputEvent"))
      weightInputEvent = @privateFormModel.get("lastFocusedInputEvent")
      weightInputTarget = weightInputEvent.target
      classNameParts = weightInputTarget.className.split(' ')
      newClassName = classNameParts[0]
      $(weightInputTarget).attr("class", newClassName)

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

    theCaller = "closeAddWorkoutDialog"

    @validateBeforeSave(theCaller)


    if @modelFormAndExercises.get("atLeastOneFieldFilled") == true
      if (confirm "Changes have been made to the form, do you want to close now?")
        console.log "click ok"
      else
        console.log "not ok"

  addNote: ->
    console.log JSON.stringify(@associatedModelUser)

  fromSaveButtonTrigger: ->
    console.log "from save button trigger"
    theCaller = "triggerSaveButton"
    @validateBeforeSave(theCaller)

  validateBeforeSave: (theCaller)->

    console.log "validating before save"

    associatedModels = @associatedModelUser.get("workout[0]").get("workout_entry")
    workoutEntryLength = associatedModels.length

    i = 0
    missingExerciseFieldCount = 0
    missingDetailFieldCount = 0
    dateInExerciseFieldCount = 0
    dateInDetailFieldCount = 0
    invalidWeightCount = 0
    invalidrepCount = 0

    while i <= workoutEntryLength - 1
      exerciseVal = associatedModels.at(i).get("exercise_id")

      #no errors are possible for exercise because valid options are chosen from the list
      #checking for 0, which corresponds with no input for exercise
      if !_.isNull(exerciseVal) and !_.isUndefined(exerciseVal) and exerciseVal == 0
        missingExerciseFieldCount++

      entryDetailLength = associatedModels.at(i).get("entry_detail").length
      entryDetailModel = associatedModels.at(i).get("entry_detail")

      j = 0
      while j <= entryDetailLength - 1
        #get the weight and rep values
        weightVal = entryDetailModel.at(j).get("weight")
        repVal = entryDetailModel.at(j).get("reps")

        #check for field errors
        if entryDetailModel.at(j).get("invalidWeight")
          ++invalidWeightCount

        if entryDetailModel.at(j).get("invalidRep")
          ++invalidrepCount

        #check for missing inputs
        if _.isNull(weightVal) and !_.isUndefined(weightVal) and !entryDetailModel.at(j).get("invalidWeight")
          missingDetailFieldCount++

        if _.isNull(repVal) and !_.isUndefined(repVal) and !entryDetailModel.at(j).get("invalidRep")
          missingDetailFieldCount++

        j++

      i++

      console.log "errors present"
      console.log(invalidWeightCount + invalidrepCount )


      console.log("missing fields")
      console.log(missingExerciseFieldCount + missingDetailFieldCount)

      console.log JSON.stringify(@associatedModelUser)



    ###
    if theCaller == "closeAddWorkoutDialog"
      totalFilledFields
    else
      @saveWorkout(totalFieldErrors, totalUnFilledFields)
    ###


  saveWorkout: (totalFieldErrors, totalUnFilledFields)->

    console.log "clicking save"

    if totalFieldErrors > 0 and totalUnFilledFields > 0
      alert "Errors and unfilled fields prevented submitting."
    else
      if totalFieldErrors > 0
        alert "Incorrect inputs on field(s)."
      else if totalUnFilledFields > 0
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



