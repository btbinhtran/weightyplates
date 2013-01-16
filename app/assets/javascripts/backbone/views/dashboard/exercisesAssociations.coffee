class Weightyplates.Models.ExercisesAssociations extends Backbone.AssociatedModel



  #Detail = new Weightyplates.Models.DetailsAssociations()

  constructor: (name) ->
    @name = name
    @relations = [
                  {
                    type: Backbone.Many,
                    key: 'details',
                    relatedModel: name
                  }
                ]
    super



  #constructor: () ->


  ###
  constructor: (relation) ->
    @relations = [
                  {
                    type: Backbone.Many,
                    key: 'details',
                    relatedModel: null
                  }
                ]


  ###




  #relations:


