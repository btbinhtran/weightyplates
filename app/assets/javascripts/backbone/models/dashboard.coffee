class Weightyplates.Models.Dashboard extends Backbone.Model

  urlRoot : '/dashboard'

  defaults:
    workout: [
      {exercise:'benchpress', weight: 150, reps: 5}
      {exercise:'back curl', weight: 200, reps: 20}
      {exercise:'leg press', weight: 300, reps: 10}
    ]

