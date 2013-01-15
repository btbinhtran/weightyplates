class Weightyplates.Models.WorkoutFormState extends Backbone.Model


  validate: (attrs) ->





  defaults:
    workoutNameHint: "Optional (defaults to timestamp)"
    exerciseCount: 0
    isFirstExerciseRow: false
    optionListEntries: null
    exerciseViews: []
    firstExercise: null
    lastExercise: null
    addDetails: 1
    recentDetailsContainer: null


