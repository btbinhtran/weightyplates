class Weightyplates.Views.WorkoutDetail extends Backbone.View

  template: JST['dashboard/workout_entry_detail']

  el: '#latest-details-container'

  events:
    'click .add-workout-reps-add-button': 'addDetails'
    'click .add-workout-reps-remove-button': 'removeDetails'
    #'blur .add-workout-exercise-entry-input': 'validateWeightChange'
    'blur .add-workout-exercise-entry-input': 'evaluateCallerOnValidate'
    'blur .add-workout-reps-input': 'validateRepChange'
    'focus .add-workout-exercise-entry-input': 'focusWeightInput'

  initialize: (options) ->
    #make all references of 'this' to reference the main object
    _.bindAll(@)

    Backbone.on("SomeViewRendered3", (element, val) ->
      #console.log element
      console.log "response to form trigger"
      @evaluateCallerOnValidate(element, val)
    , @)

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

  focusWeightInput: (event)->
    #signal to the parent form for the focused weight input
    Backbone.trigger "trackFocusedWieghtInput", event.target

  evaluateCallerOnValidate: (arg1, arg2)->
    #console.log "eval caller validate"
    #console.log arg1
    #console.log arg2

    console.log "amount of arguments are"
    console.log arguments

    if arguments.length == 1
      console.log "from click handler"
      #@validateWeightChange(arg1)
      eventTarget = arg1.target
      weightInputValue = eventTarget.value
      classNameTarget = eventTarget.className
      @validateWeightChange(eventTarget, weightInputValue, classNameTarget)

    else
      console.log "from backbone trigger"
      #@validateWeightChange(arg1, arg2)
      eventTarget = arg1
      weightInputValue = arg2
      classNameTarget = eventTarget.className
      @validateWeightChange(eventTarget, weightInputValue, classNameTarget)


  validateWeightChange: (eventTarget, weightInputValue, classNameTarget)->


    #console.log "evaluating space in the class name"

    #console.log _.indexOf(classNameTarget, " ")

    #only has one class right now because there is no space
    if _.indexOf(classNameTarget, " ") == -1

      console.log "validate weight change"

      #console.log("class name of weight target is " + classNameTarget)
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

      #console.log "weight errors are"
      #console.log  @detailsAssociation
      #console.log _.has(@detailsAssociation.errors, "Weight")

      #generate the error or remove if validated
      if _.has(@detailsAssociation.errors, "Weight") == true

        #console.log "adding weight errors"

        #signal to exercise parent for validation error count
        #@privateDetails.get("invalidWeight")


        $controlGroup.addClass('error')

        #append to the error msg box if there is not one yet
        if @privateDetails.get("weightInputError") == false
          $weightAndRepArea.append("<div class='alert alert-error weight-list-error-msg list-error-msg'>#{@detailsAssociation.errors["Weight"]}</div>")
          @privateDetails.set("weightInputError", true)
        else
          #console.log "adding error"
          errorMsg = @detailsAssociation.errors["Weight"]
          #console.log $weightLabelArea
          $weightAndRepArea.find('.weight-list-error-msg').html(errorMsg)
        @detailsAssociation.set("weight", null)
        @detailsAssociation.set("invalidWeight", true)


      else
        #console.log "weight removing error"
        $controlGroup.removeClass('error')
        $weightAndRepArea.find('.weight-list-error-msg').remove()
        @privateDetails.set("weightInputError", false)

        @detailsAssociation.set("weight", weightInputValue + "")
        #silent prevents model change event
        @detailsAssociation.unset("invalidWeight", {silent: true})



    else
      #console.log "acknowledge that blur should be disabled"
      #indicate to save button click that it should validate the last focused weight input
      #adding an addition class on the weight input to let the save button
      #know that validation is needed
      $(eventTarget).addClass("validate-weight-input")
      Backbone.trigger "SomeViewRendered2", eventTarget

  validateRepChange: (event)->
    #console.log "atttempt validate rep"

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
    else
      #console.log "reps removing error"
      $controlGroup.removeClass('error')
      $weightAndRepArea.find('.rep-list-error-msg').remove()
      @privateDetails.set("repInputError", false)

      @detailsAssociation.set("reps", repInputValue + "")
      @detailsAssociation.unset("invalidRep", {silent: true})









