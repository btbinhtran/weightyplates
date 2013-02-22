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

  initialize: (options)->
    #make all references of 'this' to reference the main object
    _.bindAll(@)

    #model for workout form and exercises
    #manual clearing of arrays properties in models
    formAndExercisesModel = new Weightyplates.Models.FormAndExercises({      exerciseViews: []})

    #prepare the option entries
    formAndExercisesModel.set("optionListEntries", formAndExercisesModel.prepareEntries())

    #create an associated user model for workouts and further nesting of associated models
    associatedUserModel = new Weightyplates.Models.AssociationUserSession()
    associatedWorkoutModel = new Weightyplates.Models.AssociationWorkout()

    console.log "newly instantiated associatedworkoutmodel"
    console.log associatedWorkoutModel

    associatedUserModel.set({workout: [associatedWorkoutModel]})

    #set the workout name date into form and exercises
    formAndExercisesModel.set("workoutNameDefault", associatedUserModel.get("workout").at(0).get("name"))

    #allows child view to notify this view of a requested change
    formAndExercisesModel.on("change:signalParentForm", @updateAssociatedModel)

    #private form model to listen to events from child views
    privateFormModel = new Weightyplates.Models.PrivateForm()

    #adding models to the form collection
    @collection = new Weightyplates.Collections.FormCollection([
      formAndExercisesModel
      associatedUserModel
      associatedWorkoutModel
      privateFormModel
    ])

    #call render

    @render()

  render: ()->
    #load the view template
    @$el.html(@template())

    #form view gets the FormAndExercises model
    exerciseViewParam =
      formAndExercisesModel: @getModel('FormAndExercises')
    new Weightyplates.Views.WorkoutExercise(exerciseViewParam)

    #add hint in workout name
    @hintInWorkoutName()

    this

  updateAssociatedModel: ->
    #add and removal check for entries
    associationWorkoutModel = @getModel('AssociationWorkout')
    formAndExerciseModel = @getModel('FormAndExercises')
    console.log "getting workout entries"
    console.log associationWorkoutModel.get("workout_entries")

    if associationWorkoutModel.get("workout_entries")
      #remove if there is already and entry
      if associationWorkoutModel.get("workout_entries")
          .get(formAndExerciseModel
          .get("recentlyRemovedExerciseAssociatedModel"))
        associationWorkoutModel.get("workout_entries")
          .remove(formAndExerciseModel
          .get("recentlyRemovedExerciseAssociatedModel"))
       else
        #add instead of overwriting if there already a workout entry
        associationWorkoutModel.get("workout_entries")
          .add(formAndExerciseModel
          .get("recentlyAddedExerciseAssociatedModel"))
    else
      workoutEntryParams =
        workout_entries: [formAndExerciseModel.get "recentlyAddedExerciseAssociatedModel"]
      associationWorkoutModel.set(workoutEntryParams)

  focusInWorkoutName: (event) ->
    $this = $(event.target)
    if $this.attr('class') == "dashboard-workout-name-input hint"
      $this.val("").removeClass("hint")

  blurInWorkoutName: (event) ->
    $this = $(event.target)
    if $this.val().length == 0
      $this
        .val(@getModel('FormAndExercises').get("workoutNameHint"))
        .addClass "hint"

  hintInWorkoutName: ->
    $workoutNameInput = @$el.find('input.dashboard-workout-name-input')
    $workoutNameInput
      .val(@getModel('FormAndExercises').get("workoutNameHint"))
      .addClass('hint')

  closeButtonConfirmationHandler: (msg, okRes, notOkRes)->
    if (confirm(msg))
      console.log okRes
    else
      console.log notOkRes

  closeAddWorkoutDialog: (event) ->
    #confirmation messages
    closeButonConfirmationMsg = @getModel('PrivateForm').get("closeButtonConfirmationMsg")
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
    workoutName = @getModel('FormAndExercises').get("workoutName")
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
    #console.log JSON.stringify(@getModel('AssociationUserSession'))
    if @$el.find('.text-area-row').length < 1
      templateNote = @templateNote()
      @$el.find('.workout-entry-exercise-and-sets-row').after(templateNote)

  divider: ->
    console.log JSON.stringify(@getModel('AssociationUserSession'))
    console.log @getModel('AssociationUserSession').toJSON()["workout"]

  fromSaveButtonTrigger: ->
    #need to specify the caller because of sharing of function with close button
    theCaller = "triggerSaveButton"
    @validateBeforeSave(theCaller)

  getWorkoutName: (event)->
    formAndExerciseModel = @getModel('FormAndExercises')
    if event.target.className.split(' ').length < 2
      formAndExerciseModel.set("workoutName", event.target.value)
    else
      formAndExerciseModel.set("workoutName", null)

  validateBeforeSave: (theCaller)->
    console.log 'associated model'
    console.log @getModel('AssociationUserSession')

    #get data from associated model to evaluate validness
    associatedModels = @getModel('AssociationUserSession').get("workout[0]").get("workout_entries")



    workoutEntryLength = associatedModels.length

    #process the data in the private model
    results = @getModel('PrivateForm').checkErrorsAndUnfilled(associatedModels, workoutEntryLength)

    #if the close button trigger this action
    if theCaller == "closeAddWorkoutDialog"
      #return information of fields to the close dialog action
      results
    else
      @saveWorkoutMsgHandler(results.totalFieldErrors, results.totalUnFilledFields)
      #console.log "save handler"

  saveWorkoutMsgHandler: (totalFieldErrors, totalUnFilledFields)->
    @saveWorkout()
    ###
    #get alert messages from model
    saveWorkoutMsg = @getModel('PrivateForm').get("saveWorkoutMsg")

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
    ###

  saveWorkout: ->
    #prepare the json for sending
    jsonData = JSON.stringify(@getModel('AssociationUserSession'))

    #formatting the jsonData by removing the first '[' and last ']'
    jsonDataLastRightBracketIndex = jsonData.lastIndexOf(']')

    intermediateString = jsonData.substring(jsonDataLastRightBracketIndex + 1)
    rightBracketRemovedJson = jsonData.substring(0, jsonDataLastRightBracketIndex) + intermediateString

    properlyFormattedJson = rightBracketRemovedJson.replace("[", '')

    #properlyFormattedJson = properlyFormattedJson.replace("workout_entry", 'workout_entries_attributes')
    #properlyFormattedJson = properlyFormattedJson.replace(/"workout_entry":/g, '"workout_entries_attributes":')

    #properlyFormattedJson = properlyFormattedJson.replace("entry_detail", 'entry_details_attributes')
    #properlyFormattedJson = properlyFormattedJson.replace(/"entry_detail":/g, '"entry_details_attributes":')

    #console.log properlyFormattedJson

    associationUserModel = @getModel('AssociationUserSession')

    console.log associationUserModel.toJSON()
    $.ajax
      type: "POST"
      url: "/api/workouts"
      dataType: "JSON"
      #contentType: 'application/json',
      data: associationUserModel.toJSON()
      #accept: 'application/json'
      success: () ->

        #console.log @
      error: (jqXHR, textStatus, errorThrown) ->
        console.log(
          "The following error occurred: " +
          textStatus + errorThrown
        )


  clickSaveMouseDown: (event)->
    event.preventDefault()

  clickSave: (event)->
    event.preventDefault()
    @$el.find(':focus').trigger('blur')
    @validateBeforeSave()

  clickCancelMouseDown: (event)->
    event.preventDefault()

  clickCancel: (event)->
    event.preventDefault()
    @$el.find(':focus').trigger('blur')
    @$el.find('#workout-form-main-close-button').trigger('click')



