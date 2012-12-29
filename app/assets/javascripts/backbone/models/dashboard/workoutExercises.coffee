
class Weightyplates.Models.Exercises extends Backbone.Model

  url: '/api/workouts.json'

  defaults: [{
    "unit": "kg"
    "name": "a name"
  }]

