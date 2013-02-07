class Weightyplates.Views.WorkoutDetail extends Backbone.View

  template: JST['dashboard/workout_entry_detail']

  el: '#latest-details-container'

  events:
    'click .add-workout-reps-add-button': 'addDetails'
    'click .add-workout-reps-remove-button': 'removeDetails'
    'blur .add-workout-weight-input': 'validateChange'
    'blur .add-workout-reps-input': 'validateChange'
    'focus .add-workout-weight-input': 'focusHighlight'
    #'click .group-set-number': 'clickOnView'

  initialize: (options) ->
    #make all references of 'this' to reference the main object
    _.bindAll(@)

    #get the exerciseAndDetails model from options
    @exerciseAndDetails = options.exerciseAndDetails

    #private model for details
    @privateDetails = new Weightyplates.Models.PrivateDetails()

    #click on details view highlight change detection
    @exerciseAndDetails.on("change:signalViewHighlight", @signalViewHighlight, @)

    #keep track of the view exercises being added and count them
    detailViews = @exerciseAndDetails.get("detailViews")
    detailViewsCount = @exerciseAndDetails.get("detailViewsCount") + 1
    detailViews.push({view:@, viewId: @cid, viewSetNumber: detailViewsCount})
    @exerciseAndDetails.set("detailViewsCount", detailViewsCount)
                      .set("detailViews", detailViews)

    #creating detailsAssociation model for this view
    associationDetailParams = {set_number: detailViewsCount + "", weight: null, reps: null}
    @detailsAssociation = new Weightyplates.Models.AssociationDetail(associationDetailParams)

    #to signal to parent view, exercise, what child has been added
    @model.set("recentlyAddedDetailsAssociatedModel", @detailsAssociation)

    @render(detailViewsCount)

  render: (detailViewsCount) ->
    #insert template into element
    @$el.append(@template())

    #attach the right set number onto the set label
    @$el.find('.add-workout-set-label').text('S' + detailViewsCount)

    #remove the id some subsequent templates can have the same id name
    @$el.removeAttr("id")

    #remove the remove button in the beginning when there is only one detail
    if @exerciseAndDetails.get("detailViews").length == 1
      $hiddenDetailRemove = @$el.find('.add-workout-reps-remove-button')
                              .addClass('hide-add-workout-reps-remove-button')
      @exerciseAndDetails.set("hiddenDetailRemoveButton",$hiddenDetailRemove)
    else
      $hiddenDetailRemove = @exerciseAndDetails.get "hiddenDetailRemoveButton"
      $hiddenDetailRemove.removeClass('hide-add-workout-reps-remove-button')

    #cache element info
    exerciseAndDetails = @model
    detailsEl = @$el
    detailsId = @cid

    #click event on the container element for highlighting of details view
    @$el.mousedown (event)->
      $this = $(this)

      #if check for presence of clicked details view
      #if already occupied that means overwrite it
      if !_.isNull(exerciseAndDetails.get("lastClickDetails")) and detailsId != exerciseAndDetails.get("lastClickDetailsCid")
        prevHighlighted = exerciseAndDetails.get("lastClickDetails")
        prevHighlighted.removeClass('high-light-details')
        prevHighlighted.find(':focus').blur()

      #add class for any click inside details if there was no class
      if $this.hasClass('high-light-details') == false
        $this.addClass('high-light-details')
        exerciseAndDetails.set("lastClickDetails", $this)
        exerciseAndDetails.set("lastClickDetailsCid", detailsId)

      #blur if the click is not into the input field
      if event.target.tagName != "INPUT"
        $(this).find(':focus').blur()

    #console.log $(event.target).closest('.details-set-weight')

    #trigger event for newly created details set
    Backbone.trigger "detailsAndExercise:newDetailsAdded", @, @cid

    this

  signalViewHighlight: ->
    console.log 'save highlight'
    #if !_.isNull(@privateDetails.get("lastClickDetails"))
    #  console.log "not null"

  addDetails: ->
    #prepare a new div to insert another details view
    @$el.parent().append("<div class='row-fluid details-set-weight' id='latest-details-container'></div>")

    #create the new details view
    new Weightyplates.Views.WorkoutDetail(model: @model, exerciseAndDetails: @exerciseAndDetails)

  removeDetails: ()->
    #list of views
    detailViews = @exerciseAndDetails.get("detailViews")

    #the current view id
    currentCiewId = @cid

    #remove detailViews reference when deleting this view
    detailViewsFiltered = _(detailViews).reject((el) ->
      el.viewId is currentCiewId
    )

    #update the exerciseAndDetails after removal
    @exerciseAndDetails.set("detailViews", detailViewsFiltered)

    #delete all events before removing view
    @stopListening()
    @undelegateEvents()
    @remove()

    #remove the exercise remove button, if only one exercise left is left as a result
    if detailViewsFiltered.length == 1
      $hiddenDetailRemove = @exerciseAndDetails.get("detailViews")[0].view.$el
        .find('.add-workout-reps-remove-button')
        .addClass('hide-add-workout-reps-remove-button')
      @exerciseAndDetails.set("hiddenDetailRemoveButton",$hiddenDetailRemove)

    #send signal to exercise to remove the detail entry from json
    signalExerciseForm = @model.get "signalExerciseForm"
    @model.set("recentlyRemovedDetailsAssociatedModel", @detailsAssociation)
          .set("signalExerciseForm", signalExerciseForm * -1)

  toTitleCase: (str) ->
    #utility function for title casing the key
    str.replace /\w\S*/g, (txt) ->
      txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()

  validnessStateKeepingForInputs: (inputType, validness)->
    #prevState is used as a temporary variable to save the actual last state
    #lastState = prevState
    #prevState = currentState
    @privateDetails.set("lastIsValidState#{inputType}", @privateDetails.get("prevIsValidState#{inputType}"))
    @privateDetails.set("prevIsValidState#{inputType}", validness)
    @privateDetails.set("currentIsValidState#{inputType}", validness)

  validateChange: (event)->
    #get the element and its value
    eventTarget = event.target
    eventTargetClassName = eventTarget.className
    inputValue = eventTarget.value

    #determine if input was from weight or reps
    if eventTargetClassName.indexOf("weight") != -1
      attributeToChange = "weight"
      addCharS = ""
    else
      attributeToChange = "rep"
      addCharS = 's'

    #attempt to set the attribute
    validateAllParam = {validateAll: true, changedAttribute: "#{attributeToChange + addCharS}"}
    @detailsAssociation.set("#{attributeToChange + addCharS}", inputValue, validateAllParam)

    #cache elements
    $parentElement = @$el
    typeOfControl = ".#{attributeToChange}-control"
    $controlGroup = $parentElement.find(typeOfControl)
    $weightAndRepArea = $parentElement.find('.weight-and-rep-inputs')

    #set the classes and keys based on input type
    inputType = @toTitleCase(attributeToChange)
    invalidAttribute = "invalid#{inputType}"
    errorClass = "#{attributeToChange}-list-error-msg"
    errorKey = "#{attributeToChange}InputError"

    #get errors if they exist
    @detailsAssociation.errors["#{inputType + addCharS}"] || ''

    #generate the error or remove if validated
    if _.has(@detailsAssociation.errors, "#{inputType + addCharS}") == true

      $controlGroup.addClass('error')

      #append to the error msg box if there is not one yet
      if @privateDetails.get(errorKey) == false
        errors = @detailsAssociation.errors["#{inputType + addCharS}"]

        #makes sure if there are multiple error messages they are started on new line
        alertMsg = "<div class='alert alert-error #{errorClass} list-error-msg'><p>#{errors.join('</br>')}</p></div>"

        $weightAndRepArea.append(alertMsg)
        @privateDetails.set(errorKey, true)
      else
        #break the array of errors on the comma with br for new line
        errorMsg = @detailsAssociation.errors["#{inputType + addCharS}"]
        $weightAndRepArea.find(".#{errorClass}").html("<p>#{errorMsg.join('</br>')}</p>")

      @detailsAssociation.set(attributeToChange, null)
      @detailsAssociation.set(invalidAttribute, true)

      console.log "error in the validation"

    else
      console.log "removing error"

      $controlGroup.removeClass('error')
      $weightAndRepArea.find(".#{errorClass}").remove()
      @privateDetails.set(errorKey, false)

      #should only set the weight if there is a valid, non-empty data value
      if inputValue != ""
        @detailsAssociation.set("#{attributeToChange + addCharS}", inputValue + "")
      else
        @detailsAssociation.set("#{attributeToChange + addCharS}", null)

      #silent prevents model change event
      @detailsAssociation.unset(invalidAttribute, {silent: true})

  focusHighlight: (event) ->
    #$(event.target).closest('.details-set-weight').addClass()
    #console.log @
    #console.log @$el

  clickOnView: (event)->
    $(event.target).closest('.details-set-weight').addClass('high-light-details')
