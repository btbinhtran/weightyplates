class Weightyplates.Views.WorkoutExercise extends Backbone.View

  template: JST['dashboard/workout_entry_exercise']

  el: '.workout-entry-exercise-and-sets-row'


  events:
    'click .add-workout-exercise-add-button': 'addExercise'
    'click .add-workout-exercise-remove-button': 'removeExercise'

  initialize: (options)->
    console.log @

    $rowContent = @$el.html()

    $newContent = $rowContent + @template()

    @$el.html($newContent)
    ###
    exerciseCount = @model.get "exerciseCount"
    exercisePhrase = "Exercise #{exerciseCount}"
    @$el.find('.add-workout-exercise-label').text(exercisePhrase)

    @model.set("exerciseCount", exerciseCount + 1)
    console.log @
    ###
  render: ->


    #this

  addExercise: (event)->
    if  $(event.target).parent().is(":visible") == true
      viewExerciseEntry = new Weightyplates.Views.WorkoutExercise(model: @model, addingExercise: "addExercise")
    #@$el.append(viewExerciseEntry.render().el)

  removeExercise: (event)->
