class Weightyplates.Models.Exercises extends Backbone.Model

  url: '/api/workouts'

  defaults:{
  "id": 1,
  "workoutName": "a name",
  "workoutEntriesDetails": [
    { "exerciseId": 1,
    "reps": 1,
    "setNumber": 1
    }
  ]
  }

