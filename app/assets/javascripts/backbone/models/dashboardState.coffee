class Weightyplates.Models.DashboardState extends Backbone.Model

  urlRoot : '/dashboard'

  defaults:
    appState: [
      {addWorkoutForm: false}
    ]

