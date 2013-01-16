class Weightyplates.Models.ExercisesAssociations extends Backbone.AssociatedModel

  constructor: (detailsConstructor) ->
    @relations = [
                  {
                    type: Backbone.Many,
                    key: 'details',
                    relatedModel: detailsConstructor
                  }
                ]
    super



