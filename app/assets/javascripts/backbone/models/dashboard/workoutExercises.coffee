class Weightyplates.Models.Exercises extends Backbone.Model

  url: '/api/workouts/new'

  defaults:{
  "id": 1,
  "workoutName": "",
  "workoutEntriesDetails": [
    { "exerciseId": "",
    "reps": "",
    "setNumber": ""
    }
  ]
  }

