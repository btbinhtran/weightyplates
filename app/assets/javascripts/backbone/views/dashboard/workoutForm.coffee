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

    @modelWorkoutFormState.on("change:signalParentForm", @updateAssociatedModelAdd)

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

  updateAssociatedModelAdd: ->
    #console.log "want a change"
    #console.log @

    if @associatedWorkout.get("workout_entry")
      #add instead of overwriting if there already a workout entry
      @associatedWorkout.get("workout_entry").add(@modelWorkoutFormState.get("recentlyAddedExerciseAssociatedModel"))
    else
      @associatedWorkout.set({workout_entry: [@modelWorkoutFormState.get "recentlyAddedExerciseAssociatedModel"]})


    #console.log JSON.stringify(@associatedModelUser)

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

    ###
    $.ajax
      type: "POST"
      url: "/api/workouts"
      dataType: "JSON"
      data:
        "workout":
          {
          "unit": $('.add-workout-units').text()
          "name": (->
            $inputWorkoutName = $("input.dashboard-workout-name-input")
            if $inputWorkoutName.length && $inputWorkoutName.not(".hint") > 0
              $inputWorkoutName.val()
            else if $inputWorkoutName.hasClass('hint')
              new Date()
          )()
          "workout_entry": [
            {
            "exercise_id": $('.add-workout-exercise-drop-downlist').find(':selected').data('id')
            "entry_detail": [
              {
              "weight": $('.add-workout-exercise-entry-input').val()
              "reps": $('.add-workout-reps-input').val()
              "set_number": $('.add-workout-set-label').text().replace(/S/g, '') * 1
              },
              {
              "weight": $('.add-workout-exercise-entry-input').val()
              "reps": $('.add-workout-reps-input').val()
              "set_number": $('.add-workout-set-label').text().replace(/S/g, '') * 1
              }

            ]
            },
            {
            "exercise_id": $('.add-workout-exercise-drop-downlist').find(':selected').data('id')
            "entry_detail": [
              {
              "weight": $('.add-workout-exercise-entry-input').val()
              "reps": $('.add-workout-reps-input').val()
              "set_number": $('.add-workout-set-label').text().replace(/S/g, '') * 1
              }

            ]
            }

          ]
          }
      success: () ->
        console.log "successful post"
      error: (jqXHR, textStatus, errorThrown) ->
        console.log(
          "The following error occurred: " +
          textStatus + errorThrown
        )
    ###


