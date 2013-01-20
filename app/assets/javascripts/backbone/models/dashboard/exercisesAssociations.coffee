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



  patterns:
    digits: "[0-9]"

  validators:
    pattern: (value,pattern) ->
      new RegExp(pattern, "gi").test(value) ? true : false

  validate: (attrs)->
    #console.log "attempt to validate"
    errors = @errors = {}

    console.log "out"
    console.log attrs.exercise_id
    if(attrs.exercise_id != null)
      console.log "in1"
      if (!attrs.exercise_id)
        console.log "in2"
        errors.exercise_id = 'Exercise is required'


    errors if !_.isEmpty(errors)


  defaults:
    exercise_id: null



