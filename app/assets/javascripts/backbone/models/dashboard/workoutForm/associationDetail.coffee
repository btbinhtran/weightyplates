class Weightyplates.Models.AssociationDetail extends Backbone.AssociatedModel

  defaults:
    weight: null
    reps: null
    set_number: null

  validator:
    patterns:
      onlyDigits:(attr) ->
        if isNaN(attr.validateAttrVal * 1)
          #console.log "not a number"
          "#{attr.checkAttribute} can only have digits."

      noNegZero:(attr) ->
        if(attr.validateAttrVal == "-0")
          "#{attr.checkAttribute} can't be negative zero."

      largerThanZero:(attr) ->
        validateAttr = attr.validateAttrVal
        if((validateAttr * 1) <= 0 and validateAttr != "" )
          "#{attr.checkAttribute} must be greater than 0."

      noPeriodEnd:(attr) ->
        validateAttr = attr.validateAttrVal
        if(!isNaN(validateAttr * 1) and _.indexOf(validateAttr, ".") == (validateAttr.length - 1) and validateAttr != "")
          "#{attr.checkAttribute} can't end with a period."

      noDeci: (attr) ->
        validateAttr = attr.validateAttrVal
        parts = validateAttr.split('.')
        if(parts.length == 2)
          "#{attr.checkAttribute} can not be a decimal."

      noLeadingZeroDeci:(attr) ->
        validateAttr = attr.validateAttrVal
        parts = validateAttr.split('.')
        if(parts[0].length > 1 and parts[0]*1 == 0)
          "#{attr.checkAttribute} has too many leading zeros in decimal."

      noLeadingInt:(attr) ->
        validateAttr = attr.validateAttrVal
        if(_.indexOf(validateAttr, ".") == -1 and (validateAttr.replace(/^0+/, '').length != validateAttr.length))
          "#{attr.checkAttribute} whole number can't have leading zeros."

      noSciNot:(attr) ->
        validateAttr = attr.validateAttrVal
        scientificParts = validateAttr.split('e')
        if(scientificParts.length == 2 and !isNaN(scientificParts[0]*1) and !isNaN(scientificParts[1]*1))
          "#{attr.checkAttribute} can't be in scientific notation."

    validateWith: (options) =>
      #to store all the errors
      errors = {}

      #get all the validation options
      validateOptions = options.ensureTrue

      #get the validation count
      itemsToValidateLength = validateOptions.length

      i = 0
      while i < itemsToValidateLength

        if !_.isUndefined(@::validator.patterns[validateOptions[i]](options))
          #storing the error if there is one
          errors[options.checkAttribute] = @::validator.patterns[validateOptions[i]](options)

          #break out of the loop
          i = itemsToValidateLength
        i++

      #return errors
      errors

    withAttribute: (attr, attrVal) ->
      #capitalize first letter of word function
      toTitleCase = (str) ->
        str.replace /\w\S*/g, (txt) ->
          txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()

      #set key for attr val
      @attrValidations[attr].validateAttrVal = attrVal

      #set key for attr name
      @attrValidations[attr].checkAttribute = toTitleCase(attr)

      #get the rules defined for the attr
      @validateWith(@attrValidations[attr])

    attrValidations:
      weight:
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
        ensureTrue: [
          "onlyDigits"
          "noSciNot"
          "noPeriodEnd"
          "noDeci"
          "noLeadingZeroDeci"
          "noNegZero"
          "largerThanZero"
          "noLeadingInt"
        ]

  validate: (attrs, options) ->
    #maker sure the validateAll option is pass before validating
    if !_.isEmpty(options)

      #set errors for model
      @errors = {}

      #errors
      @errors = @validator.withAttribute(options.changedAttribute, attrs[options.changedAttribute])

      #return errors if present
      @errors if !_.isEmpty(@errors)


