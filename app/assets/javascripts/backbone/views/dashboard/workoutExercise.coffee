class Weightyplates.Views.WorkoutExercise extends Backbone.View

  template: JST['dashboard/workout_entry_exercise']

  tagName: "div"

  className: "row-fluid"

  events:
    'click .add-workout-exercise-add-button': 'addExercise'
    'click .add-workout-exercise-remove-button': 'removeExercise'

  initialize: (options)->

    if _.isEmpty(@model.get "initializeExercise") == false
      console.log "first has gone"
      console.log "==========================="
      @$el.html(@template())



    if options.callingFrom == "form"
      console.log "the first"
      @$el.html(@template())
      exerciseCount = @model.get "exerciseCount"
      exercisePhrase = "Exercise #{exerciseCount}"
      @$el.find('.add-workout-exercise-label').text(exercisePhrase)

      @model.set("exerciseCount", exerciseCount + 1)

      @model.set("initializeExercise", @$el )


  render: ->


    this

  addExercise: (options)->
    console.log "adding"
    viewExerciseEntry = new Weightyplates.Views.WorkoutExercise(model: @model, addingExercise: "addExercise")
    @$el.append(viewExerciseEntry.render().el)

  removeExercise: (event)->
