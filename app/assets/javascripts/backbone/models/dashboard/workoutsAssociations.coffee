class Weightyplates.Models.WorkoutsAssociations extends Backbone.AssociatedModel

  constructor: () ->
    @relations = [
                  {
                    type: Backbone.Many,
                    key: 'workout_entry',
                    relatedModel: Weightyplates.Models.ExercisesAssociations
                  }
                ]
    super