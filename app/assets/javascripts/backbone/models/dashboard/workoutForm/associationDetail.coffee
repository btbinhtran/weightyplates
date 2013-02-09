class Weightyplates.Models.AssociationDetail extends Backbone.AssociatedModel

  defaults:
    weight: null
    reps: null
    set_number: null

  validator:
    patterns:
      noOnlySpaces:(attr) ->
        if $.trim(attr.validateAttrVal).length == 0
          "#{attr.checkAttribute} can not be spaces."

      noSpaces: (attr) ->
        attrVal = attr.validateAttrVal
        if attrVal.replace(" ", '').length < attrVal.length
          if attrVal.length - attrVal.replace(/\s*/g, '').length > 1
            "#{attr.checkAttribute} can not have spaces."
          else
            "#{attr.checkAttribute} can not have a space."

      onlyDigits:(attr) ->
        attrVal = attr.validateAttrVal
        if isNaN(attrVal * 1) and attrVal.replace(/\s*/g, '').length > attrVal.replace(/\D/g, '').length
          #console.log "not a number"
          "#{attr.checkAttribute} can only have digits."

      decimalIntent:(attr) ->
        attrVal = attr.validateAttrVal
        if attrVal.search(/[0-9][.]/) >=0
          "#{attr.checkAttribute} has improper decimal form if intended."

      noNegZero:(attr) ->
        if(attr.validateAttrVal == "-0")
          "#{attr.checkAttribute} can't be negative zero."

      largerThanZero:(attr) ->
        validateAttr = attr.validateAttrVal
        if((validateAttr * 1) <= 0 and validateAttr != "" and $.trim(attr.validateAttrVal).length != 0)
          "#{attr.checkAttribute} must be greater than 0."

      noPeriodEnd:(attr) ->
        validateAttr = attr.validateAttrVal
        periodAtEnd = _.indexOf(validateAttr, ".") == (validateAttr.length - 1)
        if(!isNaN(validateAttr * 1) and periodAtEnd and validateAttr != "")
          "#{attr.checkAttribute} can't end with a period."

      noDeci: (attr) ->
        validateAttr = attr.validateAttrVal
        parts = validateAttr.split('.')
        if(parts.length == 2 and parts[0].length >= 0 and parts[1].length >= 1)
          "#{attr.checkAttribute} can not be a decimal."

      noLeadingZeroDeci:(attr) ->
        validateAttr = attr.validateAttrVal
        parts = validateAttr.split('.')
        if((_.indexOf(parts[0], "0") != _.lastIndexOf(parts[0], "0")) and parts.length == 2)
          "#{attr.checkAttribute} has too many leading zeros in decimal."

      noLeadingZeroPartDeci:(attr) ->
        validateAttr = attr.validateAttrVal
        parts = validateAttr.split('.')
        if((_.indexOf(parts[0], "0") == _.lastIndexOf(parts[0], "0")) and parts[0].length ==2 and parts.length == 2 and _.indexOf(parts[0], "0") != -1)
          "#{attr.checkAttribute} has unneeded zero if decimal."

      noLeadingInt:(attr) ->
        validateAttr = attr.validateAttrVal
        if(_.indexOf(validateAttr, ".") == -1 and (validateAttr.replace(/^0+/, '').length != validateAttr.length))
          "#{attr.checkAttribute} number can't have leading zeros."

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
      errorsArray = []
      while i < itemsToValidateLength

        if !_.isUndefined(@::validator.patterns[validateOptions[i]](options))
          #for storing multiple errors
          errorsArray.push(@::validator.patterns[validateOptions[i]](options))

          #storing the error if there is one
          errors[options.checkAttribute] = errorsArray

          #break out of the loop
          #i = itemsToValidateLength
        i++

      #return errors
      errors

    utilities:
      #capitalize first letter of word function
      toTitleCase: (str) ->
        str.replace /\w\S*/g, (txt) ->
          txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()

    withAttribute: (attr, attrVal) ->
      #set key for attr val
      @attrValidations[attr].validateAttrVal = attrVal

      #set key for attr name
      @attrValidations[attr].checkAttribute = @utilities["toTitleCase"](attr)

      #get the rules defined for the attr
      @validateWith(@attrValidations[attr])

    attrValidations:
      weight:
        ensureTrue: [
          "noSpaces"
          "noOnlySpaces"
          "decimalIntent"
          "onlyDigits"
          "noNegZero"
          "largerThanZero"
          "noPeriodEnd"
          "noLeadingZeroDeci"
          "noLeadingZeroPartDeci"
          "noLeadingInt"
          "noSciNot"
        ]

      reps:
        ensureTrue: [
          "noSpaces"
          "noOnlySpaces"
          "onlyDigits"
          "noSciNot"
          "noPeriodEnd"
          "noDeci"
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


