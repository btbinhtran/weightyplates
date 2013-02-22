class Weightyplates.Models.AssociationWorkout extends Backbone.AssociatedModel

  constructor: () ->
    @relations = [
                  {
                    type: Backbone.Many,
                    key: 'workout_entries',
                    relatedModel: Weightyplates.Models.AssociationExercise
                  }
                ]
    super

  defaults:
    unit: "kg"
    name: (new Date()).format("isoDateTime")
    note: null