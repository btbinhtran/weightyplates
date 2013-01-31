class Weightyplates.Models.AssociationUserSession extends Backbone.AssociatedModel

  constructor: () ->
    @relations = [
      {
      type: Backbone.Many,
      key: 'workout',
      relatedModel: Weightyplates.Models.AssociationWorkout
      }
    ]
    super
