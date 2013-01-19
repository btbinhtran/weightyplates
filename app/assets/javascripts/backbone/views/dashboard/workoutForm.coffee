class Weightyplates.Views.WorkoutForm extends Backbone.View

  template: JST['dashboard/workout_form']

  el: '#workout-form-container'

  events:
    'click #last-row-save-button': 'saveWorkout'
    'focus input.dashboard-workout-name-input': 'focusInWorkoutName'
    'blur input.dashboard-workout-name-input': 'blurInWorkoutName'
    #'click #workout-form-main-close-button': 'closeAddWorkoutDialog'
    'click #last-row-note-button': 'addNote'

  initialize: ->
    #make all references of 'this' to reference the main object
    _.bindAll(@)

    #model for workout state
    @modelWorkoutFormState = new Weightyplates.Models.WorkoutFormState()

    #prepare the option entries
    @modelWorkoutFormState.set("optionListEntries", @modelWorkoutFormState.prepareEntries())

    #create an associated user model for workouts and further nesting of associated models
    @associatedModelUser = new Weightyplates.Models.UserSessionAssociations()
    @associatedWorkout = new Weightyplates.Models.WorkoutsAssociations()
    @associatedModelUser.set({workout: [@associatedWorkout]})

    #console.log "user session"
    #console.log @associatedModelUser

    @modelWorkoutFormState.on("change:signalParentForm", @updateAssociatedModel)

    #call render
    @render()

  render: ()->
    #load the view template
    @$el.html(@template())

    #form view gets the workoutFormState model
    new Weightyplates.Views.WorkoutExercise(model: @modelWorkoutFormState)

    #$(document).on('keypress', @closeAddWorkoutDialog)
    @hintInWorkoutName()
    this

  updateAssociatedModel: ->

    #add and removal check for entries
    if @associatedWorkout.get("workout_entry")
      #remove if there is already and entry
      if @associatedWorkout.get("workout_entry").get(@modelWorkoutFormState.get("recentlyRemovedExerciseAssociatedModel"))
        @associatedWorkout.get("workout_entry").remove(@modelWorkoutFormState.get("recentlyRemovedExerciseAssociatedModel"))
       else
        #add instead of overwriting if there already a workout entry
        @associatedWorkout.get("workout_entry").add(@modelWorkoutFormState.get("recentlyAddedExerciseAssociatedModel"))

    else
      @associatedWorkout.set({workout_entry: [@modelWorkoutFormState.get "recentlyAddedExerciseAssociatedModel"]})


    console.log JSON.stringify(@associatedModelUser)

  getEventTarget: (event)->
    $(event.target)

  focusInWorkoutName: (event) ->
    $this = @getEventTarget(event)
    $this.val("").removeClass("hint") if $this.attr('class') == "dashboard-workout-name-input hint"

  blurInWorkoutName: (event) ->
    $this = @getEventTarget(event)
    $this.val(@modelWorkoutFormState.get "workoutNameHint").addClass "hint" if $this.val().length == 0

  hintInWorkoutName: ->
    $workoutNameInput = $('input.dashboard-workout-name-input')
    $workoutNameInput.val(@modelWorkoutFormState.get "workoutNameHint").addClass('hint')

  closeAddWorkoutDialog: (event) ->

    #console.log $('.add-workout-reps-input')

    #@modelWorkoutFormState.set("age", $('.add-workout-reps-input').val())
    #console.log @modelWorkoutFormState.get "age"
    #console.log  _.size(@modelWorkoutFormState.get("exerciseViews"))

    ###
    if event.keyCode == 27 || event.type == "click"
      @model.set("showingWorkoutForm", false)
      @model.set("hidingWorkoutForm", true)
      $('.dashboard-add-workout-modal-row-show')
        .addClass("dashboard-add-workout-modal-row")
        .removeClass("dashboard-add-workout-modal-row-show")
    ###

  addNote: ->


  saveWorkout: ->

    jsonData = JSON.stringify(@associatedModelUser)

    #formatting the jsonData by removing the first '[' and last ']'
    jsonDataLastRightBracketIndex = jsonData.lastIndexOf(']')

    rightBracketRemovedJson = jsonData.substring(0, jsonDataLastRightBracketIndex) + jsonData.substring(jsonDataLastRightBracketIndex + 1)

    properlyFormattedJson = rightBracketRemovedJson.replace("[", '')




    ###
    $.ajax
      type: "POST"
      url: "/api/workouts"
      dataType: "JSON"
      contentType: 'application/json',
      data: properlyFormattedJson

      success: () ->
        console.log "successful post"
      error: (jqXHR, textStatus, errorThrown) ->
        console.log(
          "The following error occurred: " +
          textStatus + errorThrown
        )
    ###


