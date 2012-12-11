class Weightyplates.Models.Dashboard extends Backbone.Model

  urlRoot : '/dashboard'

  defaults:
    appState: [
      {addWorkoutForm: false}
    ]

