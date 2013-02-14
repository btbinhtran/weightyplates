class Weightyplates.Views.WorkoutDetail extends Backbone.View

  template: JST['dashboard/workout_entry_detail']

  el: '#latest-details-container'

  events:
    'click .add-workout-reps-add-button': 'addDetails'
    'click .add-workout-reps-remove-button': 'removeDetails'
    'blur .add-workout-weight-input': 'validateChange'
    'blur .add-workout-reps-input': 'validateChange'

  initialize: (options) ->
    #make all references of 'this' to reference the main object
    _.bindAll(@)

    #get the exerciseAndDetails model from options from other details creating this view
    exerciseAndDetailsModel = options.exerciseAndDetails

    #private model for details
    privateDetailsModel = new Weightyplates.Models.PrivateDetails()

    #keep track of the view exercises being added and count them
    detailViews = exerciseAndDetailsModel.get("detailViews")
    detailViewsCount = exerciseAndDetailsModel.get("detailViewsCount") + 1
    detailViews.push({view: @, viewId: @cid, viewSetNumber: detailViewsCount})
    exerciseAndDetailsModel.set("detailViewsCount", detailViewsCount)
      .set("detailViews", detailViews)

    #creating detailsAssociation model for this view
    associationDetailParams = {set_number: detailViewsCount + "", weight: null, reps: null}
    detailsAssociationModel = new Weightyplates.Models.AssociationDetail(associationDetailParams)

    #actual details view count
    exerciseActualDetailsViewsCount = exerciseAndDetailsModel.get("actualDetailViewsCount") + 1
    exerciseAndDetailsModel.set("actualDetailViewsCount", exerciseActualDetailsViewsCount)

    #adding models to the details collection
    @collection = new Weightyplates.Collections.DetailCollection([
      exerciseAndDetailsModel
      detailsAssociationModel
      privateDetailsModel
    ])

    @render(detailViewsCount)

  render: (detailViewsCount) ->
    #insert template into element
    @$el.append(@template())

    #attach the right set number onto the set label
    @$el.find('.add-workout-set-label').text('S' + detailViewsCount)

    #remove the id some subsequent templates can have the same id name
    @$el.removeAttr("id")

    #remove the remove button in the beginning when there is only one detail
    exerciseAndDetailsModel = @getModel('ExerciseAndDetails')
    if exerciseAndDetailsModel.get("detailViews").length == 1
      $hiddenDetailRemove = @$el.find('.add-workout-reps-remove-button')
        .addClass('hide-add-workout-reps-remove-button')
      exerciseAndDetailsModel.set("hiddenDetailRemoveButton", $hiddenDetailRemove)
      exerciseAndDetailsModel.set("hiddenDetailRemoveButton", $hiddenDetailRemove)
    else
      $hiddenDetailRemove = exerciseAndDetailsModel.get "hiddenDetailRemoveButton"
      $hiddenDetailRemove.removeClass('hide-add-workout-reps-remove-button')

    #cache element info
    detailsEl = @$el
    detailsId = @cid

    #click event on the container element for highlighting of details view
    @$el.click (event)->
      $this = $(this)

      #if check for presence of clicked details view
      #if already occupied that means overwrite it
      notNullLastClickDetails = !_.isNull(exerciseAndDetailsModel.get("lastClickDetails"))
      if notNullLastClickDetails and detailsId != exerciseAndDetailsModel.get("lastClickDetailsCid")
        prevHighlighted = exerciseAndDetailsModel.get("lastClickDetails")
        prevHighlighted.removeClass('high-light-details')
        prevHighlighted.find(':focus').blur()

      #add class for any click inside details if there was no class
      if $this.hasClass('high-light-details') == false
        #for clicks that are not on the remove button for details
        if $(event.target).hasClass('add-workout-reps-remove-button') == false
          $this.addClass('high-light-details')
          exerciseAndDetailsModel.set("lastClickDetails", $this)
          exerciseAndDetailsModel.set("lastClickDetailsCid", detailsId)
        else
          #for clicking remove on non-highlighted details
          #need this because a click on a non-highlighted details registered a last click details for the model
          lastViewFocused = exerciseAndDetailsModel.get("lastClickDetails")
          lastViewFocused.trigger("click")

      isRemoveButton = $(event.target).hasClass('add-workout-reps-remove-button')
      isVisibleRemoveButton = $('.add-workout-reps-remove-button :visible')
      hasClassHighlighted = $this.hasClass('high-light-details')

      if isRemoveButton and isVisibleRemoveButton and hasClassHighlighted
        #mark that it is highlighted but is getting deleted
        exerciseAndDetailsModel.set("recentDetailsViewAction", "highlighting")
        #signal to parent view to highlight neighboring detail view
        signalExerciseForm = exerciseAndDetailsModel.get "signalExerciseForm"
        exerciseAndDetailsModel.set("signalExerciseForm", signalExerciseForm * -1)

      #blur if the click is not into the input field
      if event.target.tagName != "INPUT"
        $(this).find(':focus').blur()

    associationDetailModel = @getModel('AssociationDetail')
    #log info for newly created details set and signal update to parent view
    exerciseAndDetailsModel.set("recentDetailsViewAction", "adding")
      .set("recentlyAddedDetailsViewId", @cid)
      .set("recentlyAddedDetailsAssociatedModelId", associationDetailModel.cid)

    #add the view id as an actual id on element
    #allows for easier referencing when sorting details
    detailsEl.attr("id", detailsId)

    #to signal to parent view, exercise, what child has been added
    exerciseAndDetailsModel.set("recentlyAddedDetailsAssociatedModel", associationDetailModel)

    this

  getModel: (modelName) ->
    _.filter(@collection.models, (model) ->
      model.constructor.name == modelName
    )[0]

  addDetails: ->
    #prepare a new div to insert another details view
    @$el.parent().append("<div class='row-fluid details-set-weight' id='latest-details-container'></div>")

    #create the new details view
    workoutDetailsParams = {exerciseAndDetails: @getModel('ExerciseAndDetails')}
    new Weightyplates.Views.WorkoutDetail(workoutDetailsParams)

  removeDetails: ()->
    #setting actual details view count
    exerciseAndDetailModel = @getModel('ExerciseAndDetails')
    actualDetailsViewCount = exerciseAndDetailModel.get("actualDetailViewsCount") - 1
    exerciseAndDetailModel.set("actualDetailViewsCount", actualDetailsViewCount)

    #list of views
    detailViews = exerciseAndDetailModel.get("detailViews")

    #the current view id
    currentCiewId = @cid

    #remove detailViews reference when deleting this view
    detailViewsFiltered = _(detailViews).reject((el) ->
      el.viewId is currentCiewId
    )

    #update the exerciseAndDetails after removal
    exerciseAndDetailModel.set("detailViews", detailViewsFiltered)

    #remove the exercise remove button, if only one exercise left is left as a result
    if detailViewsFiltered.length == 1
      $hiddenDetailRemove = exerciseAndDetailModel.get("detailViews")[0].view.$el
        .find('.add-workout-reps-remove-button')
        .addClass('hide-add-workout-reps-remove-button')
      exerciseAndDetailModel.set("hiddenDetailRemoveButton", $hiddenDetailRemove)

    thisView = @
    #console.log "start detail delete"
    #details removal fadeout animation

    ###
    @$el.fadeOut(300, ->
      #remove view and event listeners attached to it; event handlers first
      thisView.stopListening()
      thisView.undelegateEvents()
      thisView.remove()
    )
    ###

    thisView.remove()

    #console.log "end detail delete"


    #set info for view and send signal to exercise to remove the detail entry from json
    associationDetailModel = @getModel('AssociationDetail')
    signalExerciseForm = exerciseAndDetailModel.get "signalExerciseForm"
    exerciseAndDetailModel.set("recentlyRemovedDetailsAssociatedModel", associationDetailModel)
      .set("recentDetailsViewAction", "removing")
      .set("recentlyRemovedDetailsViewId", @cid)
      .set("recentlyRemovedDetailsAssociatedModelId", associationDetailModel.cid)
      .set("signalExerciseForm", signalExerciseForm * -1)

  toTitleCase: (str) ->
    #utility function for title casing the key
    str.replace /\w\S*/g, (txt) ->
      txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()

  validnessStateKeepingForInputs: (inputType, validness)->
    #prevState is used as a temporary variable to save the actual last state
    #lastState = prevState
    #prevState = currentState
    privateDetailsModel = @getModel('PrivateDetails')
    isValidState = privateDetailsModel.get("prevIsValidState#{inputType}")
    privateDetailsModel.set("lastIsValidState#{inputType}", isValidState)
                      .set("prevIsValidState#{inputType}", validness)
                      .set("currentIsValidState#{inputType}", validness)

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
    associationDetailModel = @getModel('AssociationDetail')
    validateAllParam = {validateAll: true, changedAttribute: "#{attributeToChange + addCharS}"}
    associationDetailModel.set("#{attributeToChange + addCharS}", inputValue, validateAllParam)

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
    associationDetailModel.errors["#{inputType + addCharS}"] || ''

    #generate the error or remove if validated
    privateDetailsModel = @getModel('PrivateDetails')
    if _.has(associationDetailModel.errors, "#{inputType + addCharS}") == true
      $controlGroup.addClass('error')
      #append to the error msg box if there is not one yet
      if privateDetailsModel.get(errorKey) == false
        errors = associationDetailModel.errors["#{inputType + addCharS}"]

        #makes sure if there are multiple error messages they are started on new line
        alertMsg = "<div class='alert alert-error #{errorClass} list-error-msg'><p>#{errors.join('</br>')}</p></div>"

        $weightAndRepArea.append(alertMsg)
        privateDetailsModel.set(errorKey, true)
      else
        #break the array of errors on the comma with br for new line
        errorMsg = associationDetailModel.errors["#{inputType + addCharS}"]
        $weightAndRepArea.find(".#{errorClass}").html("<p>#{errorMsg.join('</br>')}</p>")

      associationDetailModel.set("#{attributeToChange + addCharS}", null)
      associationDetailModel.set(invalidAttribute, true)

      #console.log "error in the validation"

    else
      #console.log "removing error"
      $controlGroup.removeClass('error')
      $weightAndRepArea.find(".#{errorClass}").remove()
      privateDetailsModel.set(errorKey, false)

      #should only set the weight if there is a valid, non-empty data value
      if inputValue != ""
        associationDetailModel.set("#{attributeToChange + addCharS}", inputValue + "")
      else
        associationDetailModel.set("#{attributeToChange + addCharS}", null)

      #silent prevents model change event
      associationDetailModel.unset(invalidAttribute, {silent: true})
