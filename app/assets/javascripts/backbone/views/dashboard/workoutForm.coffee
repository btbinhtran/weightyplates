class Weightyplates.Views.WorkoutForm extends Backbone.View

  template: JST['dashboard/workout_form']

  el: '#workout-form-container'

  events:
    'click #last-row-save-button': 'validateBeforeSave'
    'focus input.dashboard-workout-name-input': 'focusInWorkoutName'
    'blur input.dashboard-workout-name-input': 'blurInWorkoutName'
    #'click #workout-form-main-close-button': 'closeAddWorkoutDialog'
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

  validateBeforeSave: ->
    associatedModels = @associatedModelUser.get("workout[0]").get("workout_entry")
    workoutEntryLength = associatedModels.length

    i = 0
    j = 0
    missingExerciseFieldCount = 0
    missingDetailFieldCount = 0
    while i < workoutEntryLength
      evalifNull = associatedModels.at(i).get("exercise_id")
      if _.isNull(evalifNull) and !_.isUndefined(evalifNull)
        missingExerciseFieldCount++

        #console.log "entry details length is"
        #console.log associatedModels.at(i).get("entry_detail")
        entryDetailLength = associatedModels.at(i).get("entry_detail").length

        #console.log "j is"
        entryDetailModel = associatedModels.at(i).get("entry_detail")
        somethingCool = 89
        while j <= entryDetailLength - 1
          #console.log entryDetailModel.at(j).attributes
          evalWeightNull = entryDetailModel.at(j).get("weight")
          evalRepNull = entryDetailModel.at(j).get("reps")
          if _.isNull(evalWeightNull) and !_.isUndefined(evalWeightNull)
            missingDetailFieldCount++
          if _.isNull(evalRepNull) and !_.isUndefined(evalRepNull)
            missingDetailFieldCount++

          console.log "details intermediate"
          console.log missingDetailFieldCount

          j++

      i++
    #console.log "missing field"

    console.log "missing detail count is "
    console.log missingDetailFieldCount

    console.log "exercise error count is"
    console.log missingExerciseFieldCount

    totalFieldErrors = missingDetailFieldCount + missingExerciseFieldCount

    if totalFieldErrors > 0
      console.log "Can not be save because of missing fields."
      console.log totalFieldErrors
      console.log "-------------------------------------"
    else
      @saveWorkout()


  saveWorkout: ->

    #console.log






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



