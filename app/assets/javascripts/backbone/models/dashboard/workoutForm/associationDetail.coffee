class Weightyplates.Models.AssociationDetail extends Backbone.AssociatedModel

  defaults:
    weight: null
    reps: null
    set_number: null

  validator:
    patterns:
      onlyDigits:(attr) ->
        #console.log "in only digits"
        if isNaN(attr.validateAttribute * 1)
          #console.log "not a number"
          "#{attr.checkAttribute} can only have digits."

      noNegZero:(attr) ->
        #console.log "in no neg zero"
        if(attr.validateAttribute == "-0")
          "#{attr.checkAttribute} can't be negative zero."

      largerThanZero:(attr) ->
        validateAttr = attr.validateAttribute
        if((validateAttr * 1) <= 0 and validateAttr != "" )
          "#{attr.checkAttribute} must be greater than 0."

      noPeriodEnd:(attr) ->
        validateAttr = attr.validateAttribute
        if(!isNaN(validateAttr * 1) and _.indexOf(validateAttr, ".") == (validateAttr.length - 1) and validateAttr != "")
          "#{attr.checkAttribute} can't end with a period."

      noLeadingZeroDeci:(attr) ->
        validateAttr = attr.validateAttribute
        parts = validateAttr.split('.')
        if(parts[0].length > 1 and parts[0]*1 == 0)
          "#{attr.checkAttribute} has too many leading zeros in decimal."

      noLeadingInt:(attr) ->
        validateAttr = attr.validateAttribute
        if(_.indexOf(validateAttr, ".") == -1 and (validateAttr.replace(/^0+/, '').length != validateAttr.length))
          "#{attr.checkAttribute} whole number can't have leading zeros."

      noSciNot:(attr) ->
        validateAttr = attr.validateAttribute
        scientificParts = validateAttr.split('e')
        if(scientificParts.length == 2 and !isNaN(scientificParts[0]*1) and !isNaN(scientificParts[1]*1))
          "#{attr.checkAttribute} can't be in scientific notation."

    withRules: (options) =>
      #to store all the errors
      errors = {}

      #get all the validation options
      validateOptions = options.ensureTrue

      #get the validation count
      itemsToValidateLength = validateOptions.length

      i = 0
      while i < itemsToValidateLength

        console.log "------------------moment you been waiting for"
        if !_.isUndefined(@::validator.patterns[validateOptions[i]](options))
          #storing the error if there is one
          errors[options.checkAttribute] = @::validator.patterns[validateOptions[i]](options)

          console.log "error in middle"
          console.log errors

          #break out of the loop
          i = itemsToValidateLength
        i++

      #console.log "errors returned are"
      #console.log errors
      #return the errors
      #@errors = errors
      errors

    withAttribute: (attr, attrVal) ->
      console.log "withattr"
      #console.log attr
      #console.log attrVal
      @validateAttributes[attr].validateAttribute = attrVal
      console.log @validateAttributes[attr]
      #@::validator.validateAttributes
      @withRules(@validateAttributes[attr])

    validateAttributes:
      weight:
        checkAttribute: "Weight"
        ensureTrue: [
          "onlyDigits"
          "noNegZero"
          "largerThanZero"
          "noPeriodEnd"
          "noLeadingZeroDeci"
          "noLeadingInt"
          "noSciNot"
        ]

      reps:
        checkAttribute: "Reps"
        ensureTrue: [
          "onlyDigits"
          "noSciNot"
          "noPeriodEnd"
          "noLeadingZeroDeci"
          "noNegZero"
          "largerThanZero"
          "noLeadingInt"

        ]




  validate: (attrs, options) ->
    #maker sure the validateAll option is pass before validating
    if !_.isEmpty(options)

      errors = {}

      console.log "attr value is "
      console.log attrs[options.changedAttribute]

      #errors
      errors = @validator.withAttribute(options.changedAttribute, attrs[options.changedAttribute])

      ###
      errors = @validator.withRules(
        checkAttribute: "Weight"
        ensureTrue: [
          "onlyDigits"
          "noNegZero"
          "largerThanZero"
          "noPeriodEnd"
          "noLeadingZeroDeci"
          "noLeadingInt"
          "noSciNot"
        ]
        validateAttribute: attrs[options.changedAttribute]
      )


      errors = @validator.withRules(
        checkAttribute: "Reps"
        ensureTrue: [
          "onlyDigits"
          "noSciNot"
          "noPeriodEnd"
          "noLeadingZeroDeci"
          "noNegZero"
          "largerThanZero"
          "noLeadingInt"

        ]
        validateAttribute: attrs[options.changedAttribute]
      )
      ###



      ###



        if changedAttribute == "reps"
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

      ###

      console.log "errors before"
      console.log errors

      @errors = errors if !_.isEmpty(errors)