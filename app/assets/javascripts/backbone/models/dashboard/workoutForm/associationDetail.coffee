class Weightyplates.Models.AssociationDetail extends Backbone.AssociatedModel

  defaults:
    weight: null
    reps: null
    set_number: null

  validator:
    onlyDigits:(attr) ->
      errors = {}
      if isNaN(attr.validateAttribute * 1)
        console.log "not a number"
        errors[attr.checkAttribute] = 'Weight can only have digits.'

    noNegZero:(attr, errors) ->
      if(attr.validateAttribute == "-0")
        console.log "noNeg"
        errors[attr.checkAttribute] = "Weight can't be negative zero."

    largerThanZero:(attr,errors) ->
      validateAttr = attr.validateAttribute
      if((validateAttr * 1) <= 0 and validateAttr != "" )
        errors[attr.checkAttribute] = 'Weight must be greater than 0.'

    noPeriodEnd:(attr, errors) ->
      validateAttr = attr.validateAttribute
      if(!isNaN(validateAttr * 1) and _.indexOf(validateAttr, ".") == (validateAttr.length - 1) and validateAttr != "")
        console.log "end with period"
        errors[attr.checkAttribute] = "Weight can't end with a period."

    noLeadingZeroDeci:(attr) ->

    noLeadingInt:(attr) ->

    noSciNot:(attr) ->


    withRules: (options) =>
      #to store all the errors
      errors = {}

      validateOptions = options.ensureTrue
      #validateItemName = options.checkAttribute
      #validateAttributeValue = options.validateAttribute
      itemsToValidateLength = validateOptions.length

      i = 0
      while i < itemsToValidateLength


        errors = @::validator[validateOptions[i]](options)

        #break out of the loop because one error message is enough
        if !_.isEmpty(errors)
          i = itemsToValidateLength

        i++

      #@::validator.onlyDigits()




  validate: (attrs, options) ->
    #maker sure the validateAll option is pass before validating
    if !_.isEmpty(options)

      #define error object for errors
      errors = @errors = {}

      #references to what was attribute was changed
      changedAttribute = options.changedAttribute
      toValidateAttribute = attrs[changedAttribute]

      #break decimal into two parts for checking excess zeros
      parts = toValidateAttribute.split('.')

      #break based on single e because its also represents a scientific notation number
      scientificParts = toValidateAttribute.split('e')

      #make sure the attribute exist before checking
      if(_.has(attrs, changedAttribute))

        #checking weight attribute
        if changedAttribute == "weight"

          @validator.withRules(
            checkAttribute: "weight"
            ensureTrue: [
              "onlyDigits"
              "noNegZero"
              "largerThanZero"
              "noPeriodEnd"
              "noLeadingZeroDeci"
              "noLeadingInt"
              "noSciNot"
            ]
            validateAttribute: toValidateAttribute
          )

          ###

          #check for the presence of an weight
          if(isNaN(toValidateAttribute * 1))
            errors[changedAttribute] = 'Weight can only have digits.'
          else if(toValidateAttribute == "-0")
            errors[changedAttribute] = "Weight can't be negative zero."
          else if((toValidateAttribute * 1) <= 0 and toValidateAttribute != "" )
            errors[changedAttribute] = 'Weight must be greater than 0.'
          else if(!isNaN(toValidateAttribute * 1) and _.indexOf(toValidateAttribute, ".") == (toValidateAttribute.length - 1) and toValidateAttribute != "")
            errors[changedAttribute] = "Weight can't end with a period."
          else if(parts[0].length > 1 and parts[0]*1 == 0)
            errors[changedAttribute] = "Weight has too many leading zeros in decimal."
          else if(_.indexOf(toValidateAttribute, ".") == -1 and (toValidateAttribute.replace(/^0+/, '').length != toValidateAttribute.length))
            errors[changedAttribute] = "Weight whole number can't have leading zeros."
          else if(scientificParts.length == 2 and !isNaN(scientificParts[0]*1) and !isNaN(scientificParts[1]*1))
            errors[changedAttribute] = "Weight can't be in scientific notation."
          else
            #for clearing out unwanted errors
            errors = @errors = {}

          ###

        else if changedAttribute == "reps"
          #check for the presence of an weight
          if(isNaN(toValidateAttribute * 1))
            errors[changedAttribute] = 'Rep can only have digits.'
          else if(scientificParts.length == 2 and !isNaN(scientificParts[0]*1) and !isNaN(scientificParts[1]*1))
            errors[changedAttribute] = "Rep can't be in scientific notation."
          else if(!isNaN(toValidateAttribute * 1) and _.indexOf(toValidateAttribute, ".") == (toValidateAttribute.length - 1) and toValidateAttribute != "")
            errors[changedAttribute] = "Rep can't end with a period."
          else if(parts.length == 2)
            errors[changedAttribute] = 'Rep can not be a decimal.'
          else if(_.indexOf(toValidateAttribute, ".") == -1 and (toValidateAttribute.replace(/^0+/, '').length != toValidateAttribute.length))
            errors[changedAttribute] = "Rep can't have leading zeros."
          else if(toValidateAttribute == "-0")
            errors[changedAttribute] = "Rep can't be negative zero."
          else if((toValidateAttribute * 1) <= 0  and toValidateAttribute != "")
            errors[changedAttribute] = 'Rep must be greater than 0.'
          else
            #for clearing out unwanted errors
            errors = @errors = {}

      #return the errors on the attribute if present
      errors if !_.isEmpty(errors)