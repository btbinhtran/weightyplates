class Weightyplates.Views.WorkoutExercise extends Backbone.View

  template: JST['dashboard/workout_entry_exercise']

  tagName: "div"

  className: "exercises-and-sets row-fluid"

  events:
    'click .add-workout-exercise-add-button': 'addExercise'
    'click .add-workout-exercise-remove-button': 'removeExercise'

  initialize: (options)->


    @$el.html(@template())

    exerciseCount = @model.get "exerciseCount"
    exercisePhrase = "Exercise #{exerciseCount}"
    @$el.find('.add-workout-exercise-label').text(exercisePhrase)

    @model.set("exerciseCount", exerciseCount + 1)


  render: ->


    this

  addExercise: (options)->
    viewExerciseEntry = new Weightyplates.Views.WorkoutExercise(model: @model, addingExercise: "addExercise")
    @$el.parent().append(viewExerciseEntry.render().el)

  removeExercise: (event)->
