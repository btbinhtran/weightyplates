class Weightyplates.Models.ExercisesAssociations extends Backbone.AssociatedModel

  constructor: () ->
    @relations = [
                  {
                    type: Backbone.Many,
                    key: 'entry_detail',
                    relatedModel: Weightyplates.Models.DetailsAssociations
                  }
                ]
    super

  defaults:
    exercise_id: null



