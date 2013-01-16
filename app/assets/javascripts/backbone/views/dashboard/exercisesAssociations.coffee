class Weightyplates.Models.ExercisesAssociations extends Backbone.AssociatedModel

  Detail = new Weightyplates.Models.DetailsAssociations()

  relations: [
    {
      type: Backbone.Many,
      key: 'details',
      relatedModel: null
    }
  ]