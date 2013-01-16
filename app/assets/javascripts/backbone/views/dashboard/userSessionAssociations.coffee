class Weightyplates.Models.UserSessionAssociations extends Backbone.AssociatedModel


  constructor: () ->
    @relations = [
      {
      type: Backbone.Many,
      key: 'workout',
      relatedModel: Weightyplates.Models.WorkoutsAssociations
      }
    ]
    super
