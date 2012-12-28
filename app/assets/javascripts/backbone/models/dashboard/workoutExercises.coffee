
class Weightyplates.Models.Exercises extends Backbone.Model

  url: '/api/workouts.json'

  defaults:{
  "id": 1,
  "unit": ["kg"],
  "name": ["a name"],
  "workoutEntriesDetails": [
    { "exerciseId": 1,
    "reps": 1,
    "setNumber": 1
    }
  ]
  }

