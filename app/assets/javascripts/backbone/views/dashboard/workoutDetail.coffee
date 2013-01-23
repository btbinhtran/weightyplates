class Weightyplates.Views.WorkoutDetail extends Backbone.View

  template: JST['dashboard/workout_entry_detail']

  el: '#latest-details-container'

  events:
    'click .add-workout-reps-add-button': 'addDetails'
    'click .add-workout-reps-remove-button': 'removeDetails'
    'blur .add-workout-exercise-entry-input': 'validateWeightChange'

  initialize: (options) ->
    #make all references of 'this' to reference the main object
    _.bindAll(@)

    #get the private model from options
    @privateModel = options.privateModel

    #console.log "private model is now"
    #console.log @privateModel

    #keep track of the view exercises being added and count them
    detailViews = @privateModel.get("detailViews")
    detailViewsCount = @privateModel.get("detailViewsCount") + 1
    detailViews.push({view:@, viewId: @cid, viewSetNumber: detailViewsCount})
    @privateModel.set("detailViewsCount", detailViewsCount)
                .set("detailViews", detailViews)

    #creating detailsAssociation model for this view
    @detailsAssociation = new Weightyplates.Models.DetailsAssociations({set_number: detailViewsCount, weight: null, reps: null})


    #console.log "details"

    #to signal to parent view, exercise, what child has been added
    @model.set("recentlyAddedDetailsAssociatedModel", @detailsAssociation)

    #console.log "near details render"

    @render(detailViewsCount)

  render: (detailViewsCount) ->
    #console.log "start details render"

    #insert template into element
    @$el.append(@template())

    #attach the right set number onto the set label
    @$el.find('.add-workout-set-label').text('S' + detailViewsCount)

    #remove the id some subsequent templates can have the same id name
    @$el.removeAttr("id")

    #remove the remove button in the beginning when there is only one detail
    if @privateModel.get("detailViews").length == 1
      $hiddenDetailRemove = @$el.find('.add-workout-reps-remove-button').addClass('hide-add-workout-reps-remove-button')
      @privateModel.set("hiddenDetailRemoveButton",$hiddenDetailRemove)
      #console.log @model.get "hiddenExerciseRemoveButton"
    else
      $hiddenDetailRemove = @privateModel.get "hiddenDetailRemoveButton"
      $hiddenDetailRemove.removeClass('hide-add-workout-reps-remove-button')

    #console.log "details render"

    this

  addDetails: ->
    #prepare a new div to insert another details view
    @$el.parent().append("<div class='row-fluid details-set-weight' id='latest-details-container'></div>")

    #create the new details view
    new Weightyplates.Views.WorkoutDetail(model: @model, privateModel: @privateModel)

  removeDetails: ()->
    #console.log "removing"

    #list of views
    detailViews = @privateModel.get("detailViews")

    #the current view id
    currentCiewId = @cid

    #remove detailViews reference when deleting this view
    detailViewsFiltered = _(detailViews).reject((el) ->
      el.viewId is currentCiewId
    )

    #update the privateModel after removal
    @privateModel.set("detailViews", detailViewsFiltered)

    #delete all events before removing view
    @stopListening()
    @undelegateEvents()
    @remove()

    #remove the exercise remove button, if only one exercise left is left as a result
    if detailViewsFiltered.length == 1
      $hiddenDetailRemove = @privateModel.get("detailViews")[0].view.$el
        .find('.add-workout-reps-remove-button')
        .addClass('hide-add-workout-reps-remove-button')
      @privateModel.set("hiddenDetailRemoveButton",$hiddenDetailRemove)

    #send signal to exercise to remove the detail entry from json
    signalExerciseForm = @model.get "signalExerciseForm"
    #console.log "remove signal"
    @model.set("recentlyRemovedDetailsAssociatedModel", @detailsAssociation)
          .set("signalExerciseForm", signalExerciseForm * -1)

  validateWeightChange: (event)->
    console.log "validating weight"

    #get the element and its value
    eventTarget = event.target
    weightInputValue = eventTarget.value

    #attempt to set the attribute
    attributeToChange = "weight"
    @detailsAssociation.set(attributeToChange, weightInputValue, {validateAll: true, changedAttribute: attributeToChange})

    #cache elements
    $controlGroup = @$el.find('.weight-control')
    $weightInputSelector = "input.#{eventTarget.className}"
    $weightInput = $controlGroup.find($weightInputSelector)

    @detailsAssociation.errors["exercise_id"] || ''

    #generate the error or remove if validated
    if @privateModel.get("weightInputError") == false and  @detailsAssociation.errors["weight"]
      $controlGroup.addClass('error')








