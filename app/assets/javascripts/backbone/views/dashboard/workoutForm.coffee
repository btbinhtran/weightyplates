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
    _.bindAll(@)
    @modelWorkoutFormState = new Weightyplates.Models.WorkoutFormState()
    @modelWorkoutFormInputs = new Weightyplates.Models.WorkoutFormInputs
    @render()

  render: ()->
    #load the view template
    @$el.html(@template())

    #prepare the option entries
    @modelWorkoutFormState.set("optionListEntries", @modelWorkoutFormState.prepareEntries())

    #form view gets the workoutFormState model
    viewExerciseEntry = new Weightyplates.Views.WorkoutExercise(model: @modelWorkoutFormState)

    #$(document).on('keypress', @closeAddWorkoutDialog)
    @hintInWorkoutName()
    this

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



