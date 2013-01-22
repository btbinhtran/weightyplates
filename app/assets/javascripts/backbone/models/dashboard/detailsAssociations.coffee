class Weightyplates.Models.DetailsAssociations extends Backbone.AssociatedModel

  defaults:
    weight: null
    reps: null
    set_number: null

  patterns:
    digits: "[0-9]"

  validators:
    pattern: (value,pattern) ->
      new RegExp(pattern, "gi").test(value) ? true : false

    onlyDigits: (value) ->
      Weightyplates.Models.DetailsAssociations.prototype.validators.pattern(value, Weightyplates.Models.DetailsAssociations.prototype.patterns.digits)


  validate: (attrs, options) ->
    #console.log "validating"
    if !_.isEmpty(options)

      #define error object for errors
      errors = @errors = {}

      #references to what was attribute was changed
      changedAttribute = options.changedAttribute
      toValidateAttribute = attrs[changedAttribute]

      #make sure the attribute exist before checking
      if(_.has(attrs, changedAttribute))
        #check for the presence of an exercise id
        if (!toValidateAttribute)
          errors[changedAttribute] = 'A weight is required'
        #only digits allowed
        else if(!@validators.onlyDigits(attrs[changedAttribute]))
          errors[changedAttribute] = 'Weight can only have digits'
        else
          #safety for clearing out unwanted errors
          errors = @errors = {}

      #return the errors on the attribute if present
      errors if !_.isEmpty(errors)