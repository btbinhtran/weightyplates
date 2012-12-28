
class Weightyplates.Models.Exercises extends Backbone.Model

  url: '/api/workouts.json'

  defaults:{
    "id": 1
    "unit": "kg"
    "name": "a name"
  }

