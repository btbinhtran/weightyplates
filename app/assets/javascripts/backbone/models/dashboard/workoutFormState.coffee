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
    age: null
    enteredDataOptionList: 0
    enteredDataWeight: 0
    enteredDataReps: 0

