class Weightyplates.Models.WorkoutsAssociations extends Backbone.AssociatedModel

  paramRoot: 'workout'

  constructor: () ->
    @relations = [
                  {
                    type: Backbone.Many,
                    key: 'exercises',
                    relatedModel: Weightyplates.Models.ExercisesAssociations
                  }
                ]
    super