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
    'blur .dashboard-workout-name-input': 'getWorkoutName'
    'mousedown #last-row-cancel-button': 'clickCancelHandler'

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

    #set the workout name date into form and exercises
    @modelFormAndExercises.set("workoutNameDefault", @associatedModelUser.get("workout").at(0).get("name"))

    #allows child view to notify this view of a requested change
    @modelFormAndExercises.on("change:signalParentForm", @updateAssociatedModel)

    #private form model to listen to events from child views
    @privateFormModel = new Weightyplates.Models.PrivateForm()

    #use backbone as a global event bus for validating on blur with incorrect values
    Backbone.on("lastInputFocused", (event) ->
      @privateFormModel.set("lastFocusedInputEvent", event)
    , @)

    Backbone.on("triggerSaveButtonClick", (event) ->
      @fromSaveButtonTrigger()
    , @)

    Backbone.on("successfullyTriggerByDetails", (event) ->
      @privateFormModel.set("successfullyTriggerByDetails", true)
    , @)

    Backbone.on("hasError", (status) ->
      @privateFormModel.set("hasError", status)
      @clickCancel()
    , @)

    #call render
    @render()

  render: ()->
    #load the view template
    @$el.html(@template())

    #form view gets the FormAndExercises model
    exerciseView = new Weightyplates.Views.WorkoutExercise(model: @modelFormAndExercises)

    #add hint in workout name
    @hintInWorkoutName()
    this

  updateAssociatedModel: ->
    #add and removal check for entries
    if @associatedWorkout.get("workout_entry")
      #remove if there is already and entry
      if @associatedWorkout.get("workout_entry")
          .get(@modelFormAndExercises
          .get("recentlyRemovedExerciseAssociatedModel"))
        @associatedWorkout.get("workout_entry")
          .remove(@modelFormAndExercises
          .get("recentlyRemovedExerciseAssociatedModel"))
       else
        #add instead of overwriting if there already a workout entry
        @associatedWorkout.get("workout_entry")
          .add(@modelFormAndExercises
          .get("recentlyAddedExerciseAssociatedModel"))

    else
      @associatedWorkout.set({workout_entry: [@modelFormAndExercises.get "recentlyAddedExerciseAssociatedModel"]})

  mouseOverSaveButton: ->
    #adding a class to the weight input
    if !_.isNull(@privateFormModel.get("lastFocusedInputEvent"))
      Backbone.trigger "detailValidate", "acknowledge-save-button"

  mouseOutSaveButton: ->
    #remove the added class for the weight input
    if !_.isNull(@privateFormModel.get("lastFocusedInputEvent"))
      Backbone.trigger "detailValidate", ""

  getEventTarget: (event)->
    $(event.target)

  focusInWorkoutName: (event) ->
    $this = @getEventTarget(event)
    if $this.attr('class') == "dashboard-workout-name-input hint"
      $this.val("").removeClass("hint")

  blurInWorkoutName: (event) ->
    $this = @getEventTarget(event)
    $this.val(@modelFormAndExercises.get "workoutNameHint").addClass "hint" if $this.val().length == 0

  hintInWorkoutName: ->
    $workoutNameInput = $('input.dashboard-workout-name-input')
    $workoutNameInput.val(@modelFormAndExercises.get "workoutNameHint").addClass('hint')

  closeButtonConfirmationHandler: (msg, okRes, notOkRes)->
    if (confirm(msg))
      console.log okRes
    else
      console.log notOkRes

  closeAddWorkoutDialog: (event) ->
    #confirmation messages
    closeButonConfirmationMsg = @privateFormModel.get("closeButtonConfirmationMsg")
    changesMsg = closeButonConfirmationMsg["changes"]
    changeMsg = closeButonConfirmationMsg["change"]

    #need to assign this because of sharing of function
    theCaller = "closeAddWorkoutDialog"

    #retrieve the fields information
    fieldResults = @validateBeforeSave(theCaller)[0]

    #nicknames for fields
    unfilledFields = fieldResults.totalUnFilledFields
    totalFields = fieldResults.totalFields
    errorFields = fieldResults.totalFieldErrors
    filledFields = totalFields - unfilledFields - errorFields

    #cache the condition of the workout name
    workoutName = @modelFormAndExercises.get("workoutName")
    workoutNameCond = !_.isNull(workoutName) and !_.isUndefined(workoutName)

    changesCond = (unfilledFields < totalFields) or errorFields > 0

    #for the workout name
    if workoutNameCond
      if changesCond
        @closeButtonConfirmationHandler(changesMsg, "Yes to delete.", "No to delete.")
      else
        @closeButtonConfirmationHandler(changeMsg, "Yes to delete.", "No to delete.")

    #for when there is no workout name
    else if changesCond
      if(filledFields + errorFields == 1)
        @closeButtonConfirmationHandler(changeMsg, "Yes to delete.", "No to delete.")
      else if(filledFields > 1 or errorFields > 1 or filledFields + errorFields > 1)
        @closeButtonConfirmationHandler(changesMsg, "Yes to delete.", "No to delete.")
    else
      console.log "close out the form"

  addNote: ->
    console.log JSON.stringify(@associatedModelUser)

  fromSaveButtonTrigger: ->
    #need to specify the caller because of sharing of function with close button
    theCaller = "triggerSaveButton"
    @validateBeforeSave(theCaller)

  getWorkoutName: (event)->
    if event.target.className.split(' ').length < 2
      @modelFormAndExercises.set("workoutName", event.target.value)
    else
      @modelFormAndExercises.set("workoutName", null)

  validateBeforeSave: (theCaller)->
    #get data from associated model to evaluate validness
    associatedModels = @associatedModelUser.get("workout[0]").get("workout_entry")
    workoutEntryLength = associatedModels.length

    #process the data in the private model
    results = @privateFormModel.checkErrorsAndUnfilled(associatedModels, workoutEntryLength)

    #if the close button trigger this action
    if theCaller == "closeAddWorkoutDialog"
      #return information of fields to the close dialog action
      results
    else
      @saveWorkoutMsgHandler(results[0].totalFieldErrors, results[0].totalUnFilledFields)

  saveWorkoutMsgHandler: (totalFieldErrors, totalUnFilledFields)->
    #get alert messages from model
    saveWorkoutMsg = @privateFormModel.get("saveWorkoutMsg")

    #display appropriate alert message when error or missing fields are encountered
    if(totalFieldErrors + totalUnFilledFields) == 0
      if @privateFormModel.get("successfullyTriggerByDetails") == true
        @privateFormModel.set("successfullyTriggerByDetails", null)
      else
        @saveWorkout()
    else
      if totalFieldErrors > 0 and totalUnFilledFields > 0
        if totalFieldErrors > 1 and totalUnFilledFields > 1
          alert saveWorkoutMsg["errorsAndUnfills"]
        else if totalFieldErrors == 1 and totalUnFilledFields > 1
          alert saveWorkoutMsg["errorAndUnfills"]
        else if totalFieldErrors > 1 and totalUnFilledFields == 1
          alert saveWorkoutMsg["errorsAndUnfill"]
      else
        if totalFieldErrors > 0
          if totalFieldErrors == 1
            alert saveWorkoutMsg["oneError"]
          else
            alert saveWorkoutMsg["manyErrors"]
        else if totalUnFilledFields > 0
          if totalUnFilledFields == 1
            alert saveWorkoutMsg["missingField"]
          else
            alert saveWorkoutMsg["missingFields"]

  saveWorkout: ->

    #prepare the json for sending
    jsonData = JSON.stringify(@associatedModelUser)

    #formatting the jsonData by removing the first '[' and last ']'
    jsonDataLastRightBracketIndex = jsonData.lastIndexOf(']')

    intermediateString = jsonData.substring(jsonDataLastRightBracketIndex + 1)
    rightBracketRemovedJson = jsonData.substring(0, jsonDataLastRightBracketIndex) + intermediateString

    properlyFormattedJson = rightBracketRemovedJson.replace("[", '')


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

  clickCancelHandler: ->
    Backbone.trigger "notifyFromButton": "cancel"

  clickCancel: ->
    #cancel performs the same function as the close button
    $('#workout-form-main-close-button').trigger('click')



