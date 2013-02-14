class Weightyplates.Views.WorkoutForm extends Backbone.View

  template: JST['dashboard/workout_form']
  templateNote: JST['dashboard/workout_note']

  el: '#workout-form-container'

  events:
    'focus input.dashboard-workout-name-input': 'focusInWorkoutName'
    'blur input.dashboard-workout-name-input': 'blurInWorkoutName'
    'click #workout-form-main-close-button': 'closeAddWorkoutDialog'
    'click #last-row-note-button': 'addNote'
    'click #last-row-container': 'divider'
    'blur .dashboard-workout-name-input': 'getWorkoutName'
    'mousedown #last-row-save-button': 'clickSaveMouseDown'
    'click #last-row-save-button': 'clickSave'
    'mousedown #last-row-cancel-button': 'clickCancelMouseDown'
    'click #last-row-cancel-button': 'clickCancel'

  initialize: ->

    #make all references of 'this' to reference the main object
    _.bindAll(@)

    #model for workout state
    @formAndExercisesModel = new Weightyplates.Models.FormAndExercises()

    #prepare the option entries
    @formAndExercisesModel.set("optionListEntries", @formAndExercisesModel.prepareEntries())

    #create an associated user model for workouts and further nesting of associated models
    @associatedUserModel = new Weightyplates.Models.AssociationUserSession()
    @associatedWorkoutModel = new Weightyplates.Models.AssociationWorkout()
    @associatedUserModel.set({workout: [@associatedWorkoutModel]})

    #set the workout name date into form and exercises
    @formAndExercisesModel.set("workoutNameDefault", @associatedUserModel.get("workout").at(0).get("name"))

    #allows child view to notify this view of a requested change
    @formAndExercisesModel.on("change:signalParentForm", @updateAssociatedModel)

    #private form model to listen to events from child views
    @privateFormModel = new Weightyplates.Models.PrivateForm()

    #call render
    @render()

  render: ()->
    #load the view template
    @$el.html(@template())

    #form view gets the FormAndExercises model
    exerciseView = new Weightyplates.Views.WorkoutExercise(formAndExercisesModel: @formAndExercisesModel)

    #add hint in workout name
    @hintInWorkoutName()

    this

  getModel: (modelName) ->
    _.filter(@collection.models, (model) ->
      model.constructor.name == modelName
    )[0]

  updateAssociatedModel: ->
    #add and removal check for entries
    if @associatedWorkoutModel.get("workout_entry")
      #remove if there is already and entry
      if @associatedWorkoutModel.get("workout_entry")
          .get(@formAndExercisesModel
          .get("recentlyRemovedExerciseAssociatedModel"))
        @associatedWorkoutModel.get("workout_entry")
          .remove(@formAndExercisesModel
          .get("recentlyRemovedExerciseAssociatedModel"))
       else
        #add instead of overwriting if there already a workout entry
        @associatedWorkoutModel.get("workout_entry")
          .add(@formAndExercisesModel
          .get("recentlyAddedExerciseAssociatedModel"))

    else
      @associatedWorkoutModel.set({workout_entry: [@formAndExercisesModel.get "recentlyAddedExerciseAssociatedModel"]})

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
    $this.val(@formAndExercisesModel.get "workoutNameHint").addClass "hint" if $this.val().length == 0

  hintInWorkoutName: ->
    $workoutNameInput = $('input.dashboard-workout-name-input')
    $workoutNameInput.val(@formAndExercisesModel.get "workoutNameHint").addClass('hint')

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
    fieldResults = @validateBeforeSave(theCaller)

    #nicknames for fields
    unfilledFields = fieldResults.totalUnFilledFields
    totalFields = fieldResults.totalFields
    errorFields = fieldResults.totalFieldErrors
    filledFields = totalFields - unfilledFields - errorFields

    #cache the condition of the workout name
    workoutName = @formAndExercisesModel.get("workoutName")
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
    #console.log JSON.stringify(@associatedUserModel)
    if $('.text-area-row').length < 1
      templateNote = @templateNote()
      $('.workout-entry-exercise-and-sets-row').after(templateNote)

  divider: ->
    console.log JSON.stringify(@associatedUserModel)
    console.log @associatedUserModel.toJSON()["workout"]

  fromSaveButtonTrigger: ->
    #need to specify the caller because of sharing of function with close button
    theCaller = "triggerSaveButton"
    @validateBeforeSave(theCaller)

  getWorkoutName: (event)->
    if event.target.className.split(' ').length < 2
      @formAndExercisesModel.set("workoutName", event.target.value)
    else
      @formAndExercisesModel.set("workoutName", null)

  validateBeforeSave: (theCaller)->
    #get data from associated model to evaluate validness
    associatedModels = @associatedUserModel.get("workout[0]").get("workout_entry")
    workoutEntryLength = associatedModels.length

    #process the data in the private model
    results = @privateFormModel.checkErrorsAndUnfilled(associatedModels, workoutEntryLength)

    #if the close button trigger this action
    if theCaller == "closeAddWorkoutDialog"
      #return information of fields to the close dialog action
      results
    else
      @saveWorkoutMsgHandler(results.totalFieldErrors, results.totalUnFilledFields)
      #console.log "save handler"

  saveWorkoutMsgHandler: (totalFieldErrors, totalUnFilledFields)->
    #get alert messages from model
    saveWorkoutMsg = @privateFormModel.get("saveWorkoutMsg")

    #display appropriate alert message when error or missing fields are encountered or not
    if(totalFieldErrors + totalUnFilledFields) == 0
      @saveWorkout()
    else
      if totalFieldErrors > 0 and totalUnFilledFields > 0
        if totalFieldErrors > 1 and totalUnFilledFields > 1
          alert saveWorkoutMsg["errorsAndUnfills"]
        else if totalFieldErrors == 1 and totalUnFilledFields > 1
          alert saveWorkoutMsg["errorAndUnfills"]
        else if totalFieldErrors > 1 and totalUnFilledFields == 1
          alert saveWorkoutMsg["errorsAndUnfill"]
        else if totalFieldErrors == 1 and totalUnFilledFields == 1
          alert saveWorkoutMsg["errorAndUnfill"]
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
    jsonData = JSON.stringify(@associatedUserModel)


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

  clickSaveMouseDown: (event)->
    event.preventDefault()

  clickSave: (event)->
    event.preventDefault()
    $(':focus').trigger('blur')
    @validateBeforeSave()

  clickCancelMouseDown: (event)->
    event.preventDefault()

  clickCancel: (event)->
    event.preventDefault()
    $(':focus').trigger('blur')
    $('#workout-form-main-close-button').trigger('click')



