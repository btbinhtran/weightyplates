class Weightyplates.Models.AssociationDetail extends Backbone.AssociatedModel


  defaults:
    weight: null
    reps: null
    set_number: null

  validator:
    rules:
      noOnlySpaces:(attr) ->
        attrVal = attr.validateAttrVal
        if $.trim(attrVal).length == 0  and attrVal.length > 1
          "#{attr.checkAttribute} can not be spaces."

      noSpaces: (attr) ->
        attrVal = attr.validateAttrVal
        diffLengthCond = (attrVal.length - attrVal.replace(/\s*/g, '').length)
        if (attrVal.replace(" ", '').length < attrVal.length)
          if diffLengthCond > 1 and $.trim(attrVal).length > 0
            "#{attr.checkAttribute} can not have spaces."
          else if diffLengthCond == 1
            "#{attr.checkAttribute} can not have a space."

      onlyDigits:(attr) ->
        attrVal = attr.validateAttrVal
        notANum = isNaN(attrVal * 1)
        replacedLeadingZeroLength = attrVal.replace(/\s*/g, '').length
        replacedNonDigitsLength = attrVal.replace(/\D/g, '').length
        if notANum and replacedLeadingZeroLength > replacedNonDigitsLength
          "#{attr.checkAttribute} can only have digits."

      decimalIntent:(attr) ->
        attrVal = attr.validateAttrVal
        singleDigitLeftWithDecimal = attrVal.search(/[0-9][.]/)
        periodAndSingleDigitRight = attrVal.search(/[.][0-9]/)
        if singleDigitLeftWithDecimal >=0 and periodAndSingleDigitRight < 0
          "#{attr.checkAttribute} has improper decimal form if intended."

      noNegativeZero:(attr) ->
        if(attr.validateAttrVal == "-0")
          "#{attr.checkAttribute} can't be negative zero."

      largerThanZero:(attr) ->
        validateAttr = attr.validateAttrVal
        lessThanZero = ((validateAttr * 1) <= 0)
        notABlank = (validateAttr != "")
        notOnlySpaces = ($.trim(attr.validateAttrVal).length != 0)
        if(lessThanZero and notABlank and notOnlySpaces)
          "#{attr.checkAttribute} must be greater than 0."

      noPeriodEnd:(attr) ->
        validateAttr = attr.validateAttrVal
        periodAtEnd = (_.indexOf(validateAttr, ".") == (validateAttr.length - 1))
        notANumber = !isNaN(validateAttr * 1)
        notABlank = (validateAttr != "")
        if(notANumber and periodAtEnd and notABlank)
          "#{attr.checkAttribute} can't end with a period."

      noDecimal: (attr) ->
        validateAttr = attr.validateAttrVal
        parts = validateAttr.split('.')
        leftAndRight = (parts.length == 2)
        leftMoreThanZero = (parts[0].length >= 0)
        partOne = parts[1] || false
        rightGreaterEqualOne = (partOne || false)
        if(leftAndRight and leftMoreThanZero and rightGreaterEqualOne)
          "#{attr.checkAttribute} can not be a decimal."

      noLeadingZeroDecimal:(attr) ->
        validateAttr = attr.validateAttrVal
        parts = validateAttr.split('.')
        moreThanOneZero = (_.indexOf(parts[0], "0") != _.lastIndexOf(parts[0], "0"))
        leftAndRight = (parts.length == 2)
        if(moreThanOneZero and leftAndRight)
          "#{attr.checkAttribute} has too many leading zeros in decimal."

      noLeadingZeroPartDecimal:(attr) ->
        validateAttr = attr.validateAttrVal
        parts = validateAttr.split('.')
        onlyOneZero = (_.indexOf(parts[0], "0") == _.lastIndexOf(parts[0], "0"))
        twoDigitsLeftOfDecimal = (parts[0].length == 2)
        twoParts = (parts.length == 2)
        if(onlyOneZero and twoDigitsLeftOfDecimal and twoParts)
          "#{attr.checkAttribute} has unneeded zero if decimal."

      noLeadingInteger:(attr) ->
        validateAttr = attr.validateAttrVal
        hasNoPeriod = (_.indexOf(validateAttr, ".") == -1)
        leadingZerosPresent = (validateAttr.replace(/^0+/, '').length != validateAttr.length)
        lengthGreaterThanOne = (validateAttr.length > 1)
        if(hasNoPeriod and leadingZerosPresent and lengthGreaterThanOne)
          "#{attr.checkAttribute} number can't have leading zeros."

      noScientificNotation:(attr) ->
        validateAttr = attr.validateAttrVal
        scientificParts = validateAttr.split('e')
        inScientificNotations = (scientificParts.length == 2)
        leftIsNumber = !isNaN(scientificParts[0]*1)
        rightIsNumber = !isNaN(scientificParts[1]*1)
        if(inScientificNotations and leftIsNumber and rightIsNumber)
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
        validateOption = @::validator.rules[validateOptions[i]](options)
        if !_.isUndefined(validateOption)
          #for storing multiple errors
          errorsArray.push(validateOption)

          #storing the error if there is one
          errors[options.checkAttribute] = errorsArray

        i++

      #return errors
      errors

    withAttribute: (attr, attrVal) =>
      #cache a reference to parent object
      validator = @::validator
      attrAndRules = validator.attrValidations[attr]

      #set key for attr val
      attrAndRules.validateAttrVal = attrVal

      #set key for attr name
      attrAndRules.checkAttribute = @::toTitleCase(attr)

      #get the rules defined for the attr
      validator.validateWith(attrAndRules)

    attrValidations:
      weight:
        ensureTrue: [
          "noSpaces"
          "noOnlySpaces"
          "decimalIntent"
          "onlyDigits"
          "noNegativeZero"
          "largerThanZero"
          "noPeriodEnd"
          "noLeadingZeroDecimal"
          "noLeadingZeroPartDecimal"
          "noLeadingInteger"
          "noScientificNotation"
        ]

      reps:
        ensureTrue: [
          "noSpaces"
          "noOnlySpaces"
          "onlyDigits"
          "noScientificNotation"
          "noPeriodEnd"
          "noDecimal"
          "noNegativeZero"
          "largerThanZero"
          "noLeadingInteger"
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


