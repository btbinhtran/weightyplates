class Weightyplates.Views.WorkoutDetail extends Backbone.View

  template: JST['dashboard/workout_entry_detail']

  el: '#latest-details-container'

  events:
    'click .add-workout-reps-add-button': 'addDetails'
    'click .add-workout-reps-remove-button': 'removeDetails'
    'blur .add-workout-exercise-entry-input': 'validateWeightChange'
    'focus .add-workout-exercise-entry-input': 'lastWeightInputFocused'
    'focus .add-workout-reps-input': 'lastWeightInputFocused'
    'blur .add-workout-reps-input': 'validateRepChange'

  initialize: (options) ->
    #make all references of 'this' to reference the main object
    _.bindAll(@)

    #get the exerciseAndDetails model from options
    @exerciseAndDetails = options.exerciseAndDetails

    #private model for details
    @privateDetails = new Weightyplates.Models.PrivateDetails()

    #keep track of the view exercises being added and count them
    detailViews = @exerciseAndDetails.get("detailViews")
    detailViewsCount = @exerciseAndDetails.get("detailViewsCount") + 1
    detailViews.push({view:@, viewId: @cid, viewSetNumber: detailViewsCount})
    @exerciseAndDetails.set("detailViewsCount", detailViewsCount)
                .set("detailViews", detailViews)

    #creating detailsAssociation model for this view
    @detailsAssociation = new Weightyplates.Models.AssociationDetail({set_number: detailViewsCount + "", weight: null, reps: null})

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
      $hiddenDetailRemove = @$el.find('.add-workout-reps-remove-button').addClass('hide-add-workout-reps-remove-button')
      @exerciseAndDetails.set("hiddenDetailRemoveButton",$hiddenDetailRemove)
      #console.log @model.get "hiddenExerciseRemoveButton"
    else
      $hiddenDetailRemove = @exerciseAndDetails.get "hiddenDetailRemoveButton"
      $hiddenDetailRemove.removeClass('hide-add-workout-reps-remove-button')

    this

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

  lastWeightInputFocused: (event)->
    Backbone.trigger "lastInputFocused", event

  validateWeightChange: (event)->

    console.log "validate weight change"

    #get the element and its value
    eventTarget = event.target
    weightInputValue = eventTarget.value

    #attempt to set the attribute
    attributeToChange = "weight"
    @detailsAssociation.set(attributeToChange, weightInputValue, {validateAll: true, changedAttribute: attributeToChange})

    #cache elements
    $parentElement = @$el
    $controlGroup = $parentElement.find('.weight-control')

    $weightAndRepArea = $parentElement.find('.weight-and-rep-inputs')

    $weightInputSelector = "input.#{eventTarget.className}"
    $weightInput = $controlGroup.find($weightInputSelector)

    #get errors if they exist
    @detailsAssociation.errors["Weight"] || ''

    #generate the error or remove if validated
    if _.has(@detailsAssociation.errors, "Weight") == true

      $controlGroup.addClass('error')

      #append to the error msg box if there is not one yet
      if @privateDetails.get("weightInputError") == false
        $weightAndRepArea.append("<div class='alert alert-error weight-list-error-msg list-error-msg'>#{@detailsAssociation.errors["Weight"]}</div>")
        @privateDetails.set("weightInputError", true)
      else
        #console.log "adding error"
        errorMsg = @detailsAssociation.errors["Weight"]
        $weightAndRepArea.find('.weight-list-error-msg').html(errorMsg)
      @detailsAssociation.set("weight", null)
      @detailsAssociation.set("invalidWeight", true)

      console.log "errors set"

      #if there is a new class on the weight input, trigger a save button click
      if $(eventTarget).hasClass("acknowledge-save-button")
        Backbone.trigger "triggerSaveButtonClick"

    else
      $controlGroup.removeClass('error')
      $weightAndRepArea.find('.weight-list-error-msg').remove()
      @privateDetails.set("weightInputError", false)

      #should only set the weight if there is a valid, non-empty data value
      if weightInputValue != ""
        @detailsAssociation.set("weight", weightInputValue + "")
      else
        @detailsAssociation.set("weight", null)
      #silent prevents model change event
      @detailsAssociation.unset("invalidWeight", {silent: true})


  validateRepChange: (event)->

    #get the element and its value
    eventTarget = event.target
    repInputValue = eventTarget.value

    #attempt to set the attribute
    attributeToChange = "reps"
    @detailsAssociation.set(attributeToChange, repInputValue, {validateAll: true, changedAttribute: attributeToChange})

    $parentElement = @$el
    $controlGroup = $parentElement.find('.rep-control')

    $weightAndRepArea = $parentElement.find('.weight-and-rep-inputs')

    #get errors if they exist
    @detailsAssociation.errors["Reps"] || ''

    #generate the error or remove if validated
    if _.has(@detailsAssociation.errors, "Reps") == true
      #console.log "adding errors"

      $controlGroup.addClass('error')

      #console.log "repintput error"
      #console.log @privateDetails.get("repInputError")

      #append to the error msg box if there is not one yet
      if @privateDetails.get("repInputError") == false

        #console.log "in the reps error adding"
        $weightAndRepArea.append("<div class='alert alert-error rep-list-error-msg list-error-msg'>#{@detailsAssociation.errors["Reps"]}</div>")
        @privateDetails.set("repInputError", true)
        @detailsAssociation.set("invalidRep", true)
      else
        #console.log "still adding error"
        errorMsg = @detailsAssociation.errors["Reps"]
        #console.log $weightLabelArea
        $weightAndRepArea.find('.rep-list-error-msg').html(errorMsg)

      #if there is a new class on the weight input, trigger a save button click
      if $(eventTarget).hasClass("acknowledge-save-button")
        Backbone.trigger "triggerSaveButtonClick"
    else
      #console.log "reps removing error"
      $controlGroup.removeClass('error')
      $weightAndRepArea.find('.rep-list-error-msg').remove()
      @privateDetails.set("repInputError", false)

      @detailsAssociation.set("reps", repInputValue + "")

      #should only set the rep if there is a valid, non-empty data value
      if repInputValue != ""
        @detailsAssociation.set("reps", weightInputValue + "")
      else
        @detailsAssociation.set("reps", null)
      @detailsAssociation.unset("invalidRep", {silent: true})









