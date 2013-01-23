class Weightyplates.Models.AssociationExercise extends Backbone.AssociatedModel

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

    #minLength: (value, minLength) ->
    #  value.length >= minLength

  validate: (attrs, options) ->
    #check to make sure that the options present; initializing variables  runs validate but options aren't passed
    if !_.isEmpty(options)

      #for storing the error messages on the attribute changed
      errors = @errors = {}

      #references to what was attribute was changed
      changedAttribute = options.changedAttribute
      toValidateAttribute = attrs[changedAttribute]

      #make sure the attribute exist before checking
      if(toValidateAttribute != null)

        #check for the presence of an exercise id
        if (!toValidateAttribute)
          errors[changedAttribute] = 'An exercise is required.'

      #return the errors on the attribute if present
      errors if !_.isEmpty(errors)

  defaults:
    exercise_id: null



