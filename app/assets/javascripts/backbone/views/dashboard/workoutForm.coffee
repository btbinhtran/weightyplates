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

    #add hint in workout name
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
      Backbone.trigger "detailValidate", "acknowledge-save-button"

  mouseOutSaveButton: ->
    #remove the added class for the weight input
    if !_.isNull(@privateFormModel.get("lastFocusedInputEvent"))
      Backbone.trigger "detailValidate", ""

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

    #need to assign this because of sharing of function
    theCaller = "closeAddWorkoutDialog"

    #retrieve the fields information
    fieldResults = @validateBeforeSave(theCaller)

    #nicknames for fields
    unfilledFields = fieldResults.unfilledFields
    totalFields = fieldResults.totalFields
    errorFields = fieldResults.errorFields

    #cache the condition of the workout name
    workoutName = @modelFormAndExercises.get("workoutName")
    workouNameCond = !_.isNull(workoutName) and !_.isUndefined(workoutName)

    changesCond = (unfilledFields < totalFields) || errorFields > 0

    #for the workout name
    if workouNameCond
      if changesCond
        alert "Changes have been made, exit right now without saving?"
      else
        alert "A change has been made, exit right not without saving?"

    #for when there is no workout name
    else if changesCond
      if((totalFields - unfilledFields) == 1 and errorFields == 0) || errorFields == 1 and unfilledFields < 1
        alert "A change has been made, exit right not without saving?"
      else
        alert "Changes have been made, exit right now without saving?"


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

    associatedModels = @associatedModelUser.get("workout[0]").get("workout_entry")
    workoutEntryLength = associatedModels.length

    i = 0
    missingExerciseFieldCount = 0
    missingDetailFieldCount = 0
    dateInExerciseFieldCount = 0
    dateInDetailFieldCount = 0
    invalidWeightCount = 0
    invalidrepCount = 0
    exerciseCount = 0
    detailCount = 0

    while i <= workoutEntryLength - 1
      exerciseVal = associatedModels.at(i).get("exercise_id")

      #no errors are possible for exercise because valid options are chosen from the list
      #checking for 0, which corresponds with no input for exercise
      if !_.isNull(exerciseVal) and !_.isUndefined(exerciseVal) and exerciseVal == 0
        missingExerciseFieldCount++

        #exercise counter
        ++exerciseCount

      entryDetailLength = associatedModels.at(i).get("entry_detail").length
      entryDetailModel = associatedModels.at(i).get("entry_detail")

      j = 0
      while j <= entryDetailLength - 1
        #get the weight and rep values
        weightVal = entryDetailModel.at(j).get("weight")
        repVal = entryDetailModel.at(j).get("reps")

        #details counter
        detailCount += 2

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

      #console.log "errors present"
      #console.log(invalidWeightCount + invalidrepCount )

      totalFieldErrors = invalidWeightCount + invalidrepCount

      totalFields = exerciseCount + detailCount


      #console.log("missing fields")
      #console.log(missingExerciseFieldCount + missingDetailFieldCount)

      totalUnFilledFields = missingExerciseFieldCount + missingDetailFieldCount

      #console.log JSON.stringify(@associatedModelUser)



    #if the close button trigger this action
    if theCaller == "closeAddWorkoutDialog"
      #return information of fields to the close dialog action
      {totalFields: totalFields, unfilledFields: totalUnFilledFields, errorFields: totalFieldErrors}
    else
      @saveWorkout(totalFieldErrors, totalUnFilledFields)



  saveWorkout: (totalFieldErrors, totalUnFilledFields)->

    #console.log "clicking save"
    if(totalFieldErrors + totalUnFilledFields) == 0
      alert "Good to go, no errors or missing fields."
    else
      if totalFieldErrors > 0 and totalUnFilledFields > 0
        alert "Errors and unfilled fields prevented submitting."
      else
        if totalFieldErrors > 0
          if totalFieldErrors == 1
            alert "There is an error on a field."
          else
            alert "There are many fields with errors."
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



