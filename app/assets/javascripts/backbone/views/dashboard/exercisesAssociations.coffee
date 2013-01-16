class Weightyplates.Models.ExercisesAssociations extends Backbone.AssociatedModel

  #Detail = new Weightyplates.Models.DetailsAssociations()

  constructor: () ->
    @relations = [
                  {
                    type: Backbone.Many,
                    key: 'details',
                    relatedModel: Weightyplates.Models.DetailsAssociations
                  }
                ]
    super



