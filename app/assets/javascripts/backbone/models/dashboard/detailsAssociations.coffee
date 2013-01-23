class Weightyplates.Models.DetailsAssociations extends Backbone.AssociatedModel

  defaults:
    weight: null
    reps: null
    set_number: null

  patterns:
    digits: "/^\d+$/"

  validators:
    pattern: (value,pattern) ->
      new RegExp(pattern, "gi").test(value) ? true : false

    onlyDigits: (value) ->
      Weightyplates.Models.DetailsAssociations.prototype.validators.pattern(value, Weightyplates.Models.DetailsAssociations.prototype.patterns.digits)

  validate: (attrs, options) ->
    #maker sure the validateAll option is pass before validating
    if !_.isEmpty(options)

      #define error object for errors
      errors = @errors = {}

      #references to what was attribute was changed
      changedAttribute = options.changedAttribute
      toValidateAttribute = attrs[changedAttribute]

      #for determining if there are too many leading zeros for integer or decimal
      parts = toValidateAttribute.toString().split('.')

      #make sure the attribute exist before checking
      if(_.has(attrs, changedAttribute))

        #checking weight attribute
        if changedAttribute == "weight"
          #check for the presence of an weight
          if (!toValidateAttribute)
            errors[changedAttribute] = 'A weight is required.'
          else if(isNaN(toValidateAttribute * 1))
            errors[changedAttribute] = 'Weight can only have digits.'
          else if(toValidateAttribute == "-0")
            errors[changedAttribute] = 'Negative zero does not exist.'
          else if((toValidateAttribute * 1) <= 0)
            errors[changedAttribute] = 'Weight must be greater than 0.'
          else if(!isNaN(toValidateAttribute * 1) and _.indexOf(toValidateAttribute, ".") == (toValidateAttribute.length - 1))
            errors[changedAttribute] = "Weight can't end with a period."
          else if(parts[0].length > 1 and parts[0]*1 == 0)
            errors[changedAttribute] = "Too many leading zeros in decimal"
          else if(_.indexOf(toValidateAttribute, ".") == -1 and (toValidateAttribute.replace(/^0+/, '').length != toValidateAttribute.length))
            errors[changedAttribute] = "Weight has too many leading zeros"
          else
            #safety for clearing out unwanted errors
            errors = @errors = {}

      #return the errors on the attribute if present
      errors if !_.isEmpty(errors)