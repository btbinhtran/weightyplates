class Weightyplates.Views.WorkoutExercise extends Backbone.View

  template: JST['dashboard/workout_entry_exercise']

  events:
    'click .add-workout-exercise-add-button': 'addExercise'
    'click .add-workout-exercise-remove-button': 'removeExercise'
    'click .add-workout-exercise-drop-downlist': 'checkForEntries'
    'focus .add-workout-exercise-drop-downlist': 'checkForEntries'
    'blur .add-workout-exercise-drop-downlist': 'validateListChange'

  el: '#exercise-grouping'

  #==============================================Initialize
  initialize: ()->
    #make all references of 'this' to reference the main object
    _.bindAll(@)

    #keep track of the exerciseviews and count
    exerciseViews = @model.get("exerciseViews")
    exerciseViewsCount = @model.get("exerciseViewsCount") + 1
    exerciseViews.push({view:@, viewId: @cid, viewExerciseNumber: exerciseViewsCount})
    @model.set("exerciseViewsCount", exerciseViewsCount)
    @model.set("exerciseViews", exerciseViews)

    #need to add one for starting at a zero index
    exercisePhrase = "Exercise #{exerciseViewsCount}"

    #creating exerciseAssociation model for this view
    associationExerciseParams = {workout_entry_number: exerciseViewsCount + "", exercise_id: 0}
    @exerciseAssociation = new Weightyplates.Models.AssociationExercise(associationExerciseParams)

    #model shared between the form and the exercise
    exerciseAssociatedModels = @model.get("exerciseAssociatedModels")

    #add to the exercise association model array tracker
    exerciseAssociatedModels.push(@exerciseAssociation)
    @model.set("exerciseAssociatedModels", exerciseAssociatedModels)

    #indicate which exercise associated model was recently added
    @model.set("recentlyAddedExerciseAssociatedModel", @exerciseAssociation)


    #console.log "exercise before"
    #console.log @exerciseAndDetails



    #model between exercises and details
    @exerciseAndDetails = new Weightyplates.Models.ExerciseAndDetails()

    #console.log "exercise after"
    #console.log @exerciseAndDetails

    #manual reset of details index views
    #not clearing properly for newly created exercises
    @exerciseAndDetails.set("detailsViewIndex", [])

    #console.log mostRecentDetailView
    #console.log _.last(mostRecentDetailView)

    #console.log "new exercise created and the exerciseanddetails model"
    #console.log @exerciseAndDetails

    #allows child view to request a change in associated model for the parent
    @exerciseAndDetails.on("change:recentlyAddedDetailsAssociatedModel", @updateAssociatedModelAdd, @)

    #console.log "this exercise detail"

    #console.log "model now is"
    #console.log @exerciseAndDetails

    #allows parent view to know of this view's requests
    @exerciseAndDetails.on("change:signalExerciseForm", @updateDetailsHandler, @)

    #private model for exercise
    @privateExerciseModel = new Weightyplates.Models.PrivateExercise()

    ###
    #get the child detail view
    Backbone.on("detailsAndExercise:newDetailsAdded", (view, id, aId) ->
     ##console.log "the details association id is"
     ##console.log aId
      prevNewlyAddedDetails = @privateExerciseModel.get("newlyAddedDetails")
      prevNewlyAddedDetails.push({id:id, aId: aId, index: prevNewlyAddedDetails.length})
      @privateExerciseModel.set("newlyAddedDetails", prevNewlyAddedDetails)

      view.privateDetails.set("triggerFromExercise", "fromExercise")
    , @)

    Backbone.on("detailsAndExercise:requestHighlighting", ->
     ##console.log "highlighting is requested"
      detailForHighlighting = @exerciseAndDetails.get("toBeHighlightedDetail")
     ##console.log @$el.find('#' + detailForHighlighting).trigger('click')
    , @)
    ###



    #render the template
    @render(exercisePhrase, @model.get("optionListEntries"), exerciseViewsCount)

  #==============================================Render
  render: (exercisePhrase, optionsList, exerciseViewsCount)->
    viewElModel = @model

    #the main exercise row
    $workoutExeciseRow = @$el

    #----------------------------------------------Generate a Exercise View and Details

    #append template because there will be further exercise entries
    $workoutExeciseRow.append(@template())

    #remove the id of the exercise row because subsequent exercise will have the same id
    @$el.removeAttr("id")

    #remove the remove button in the beginning when there is only one exercise
    if @model.get("exerciseViews").length == 1
      $hiddenExerciseRemove = @$el.find('.add-workout-exercise-remove-button').addClass('hide-add-workout-button')
      @model.set("hiddenExerciseRemoveButton",$hiddenExerciseRemove)
    else
      $hiddenExerciseRemove = @model.get "hiddenExerciseRemoveButton"
      $hiddenExerciseRemove.removeClass('hide-add-workout-button')

    #details container is for the set and weight rows
    $detailsContainer = $workoutExeciseRow.find('.an-entry-detail')

    #preparing an additional container for the set and weight rows
    $detailsContainer.append("<div class='row-fluid details-set-weight' id='latest-details-container'></div>")

    #the workout details row has a model between the exercises and its details
    #have to initialize model to default values because it can take on old values from other exercise sets
    @exercisesAndDetailsModel = new Weightyplates.Models.ExerciseAndDetails(detailViews: [], detailViewsCount: null)
    new Weightyplates.Views.WorkoutDetail(model: @exerciseAndDetails, exerciseAndDetails: @exercisesAndDetailsModel)

    #add the number label for the exercise; remove id because subsequent entries will have the same id
    $('#an-Exercise-label').text(exercisePhrase).removeAttr("id")

    #----------------------------------------------Event Listener: Hover Intent

    #settings for the hoverIntent plugin
    #only load the exercises when the mouses hovers over the select list
    settings =
      sensitivity: 10
      interval: 10
      over: ->
        $(@).html(optionsList)
        $(@).off()
      out: ->

    #insert entries into option list
    $optionLists =  $workoutExeciseRow.find('.add-workout-exercise-drop-downlist')

    #attaching event listener here because it's not a backbone event
    $optionLists.hoverIntent settings

    $detailsSet = $(@.el).find('.dashboard-exercise-set')

    #exercise and details model
    exerciseAndDetailsModel = @exercisesAndDetailsModel

    #exercise association model
    exerciseAssociationModel = @exerciseAssociation

    #make the details sortable
    $detailsSet.sortable
      axis: 'y'
      opacity: 0.9
      containment: 'parent'
      placeholder: 'place-holder'
      forcePlaceHolderSize: true
      delay: 100
      revert: 50
      deactivate: (event, ui)->
        console.log "sorting done"
        detailViews = exerciseAndDetailsModel.get("detailViews")
        droppedItem = _.where(detailViews, {viewId: $(ui.item).attr("id")})
        console.log droppedItem[0].view.privateDetails.get("repInputError")
        #if the prev is blank than it is first
        $prevItem = $(ui.item).prev('.details-set-weight')
        if $prevItem.length == 1
          #console.log "there is something before it"
          #get the item before the dragged item and move dragged item after that item
          #console.log $prevItem
        else
          #console.log "nothing before it now"
          #the next item after last dropped
          #console.log $(ui.item).next('.details-set-weight')
          #get the item after dragged item and move dragged item before that item
        #update the exercise association model appropriately
        #console.log exerciseAssociationModel.get("entry_detail")

    #highlight the first details upon exercise creation
    $(@.el).find('.details-set-weight').trigger("click")

    #return this
    this

  updateAssociatedModelAdd: ->
    #console.log "adding a detail view for exercise---------------------------_"
    #console.log @

    #console.log @exerciseAndDetails
    #console.log @exerciseAndDetails.attributes

    #entry details updated the parent exercise
    #subsequent entry details will be added instead
    if @exerciseAssociation.get("entry_detail")
      @exerciseAssociation.get("entry_detail")
        .add(@exerciseAndDetails
        .get("recentlyAddedDetailsAssociatedModel"))
    else
      @exerciseAssociation.set({entry_detail: [@exerciseAndDetails.get("recentlyAddedDetailsAssociatedModel")]})

    #keep track of the added details
    viewId = @exerciseAndDetails.get("recentlyAddedDetailsViewId")
    associationId = @exerciseAndDetails.get("recentlyAddedDetailsAssociatedModelId")
    detailsViewInfo = {id: viewId, aId: associationId}
    detailsIndex = @exerciseAndDetails.get("detailsViewIndex")



    detailsIndex.push(detailsViewInfo)

   ##console.log "details index is "
   ##console.log detailsIndex

    @exerciseAndDetails.set("detailsViewIndex", detailsIndex)

    #signal to parent view that a update is needed
    @model.set("signalParentForm", @model.get("signalParentForm") * -1)

  updateDetailsHandler: ->
   ##console.log "responding to a request"

    request = @exerciseAndDetails.get("recentDetailsViewAction")
    if request == "removing"
      @updateAssociatedModelRemove()
    else if request == "highlighting"
      @highLightDetails()

  highLightDetails: ->
    console.log "highlighting details"
    detailForHighlighting = @exerciseAndDetails.get("toBeHighlightedDetail")
    @$el.find('#' + detailForHighlighting).trigger('click')


  updateAssociatedModelRemove: ()->
    #console.log "begin update associated model remove"

   ##console.log "in the exercise removal"

    recentlyRemovedAssociatedModelId = @exerciseAndDetails.get("recentlyRemovedDetailsAssociatedModel").cid

    #console.log recentlyRemovedAssociatedModelId

    detailsInfo = @exerciseAndDetails.get("detailsViewIndex")
    #console.log @exerciseAndDetails

   ##console.log detailsInfo


    indexOfDeleted = null
    itemTracked = null
    toHighLightDetailView = null

    _(detailsInfo).each (el) ->
      if(el.aId == recentlyRemovedAssociatedModelId)

        indexOfDeleted = _.indexOf(detailsInfo, el)
        if(indexOfDeleted == detailsInfo.length - 1)
         ##console.log("get the previous one")
          toHighLightDetailView = detailsInfo[indexOfDeleted - 1]
        else
         ##console.log('one after')
          toHighLightDetailView = detailsInfo[indexOfDeleted + 1]
        itemTracked = detailsInfo[indexOfDeleted]

    @exerciseAndDetails.set("toBeHighlightedDetail", toHighLightDetailView.id)

    #update the private model details views for removing a detail
    @exerciseAndDetails.set("detailsViewIndex", _.difference(detailsInfo, itemTracked))

    ###
   ##console.log "recently removed-------"
    recentlyRemovedAssociatedModelId = @exerciseAndDetails.get("recentlyRemovedDetailsAssociatedModel").cid

    detailsInfo = @privateExerciseModel.get("newlyAddedDetails")
    #console.log JSON.stringify(detailsInfo)
    #console.log  @exerciseAndDetails.get("recentlyRemovedDetailsAssociatedModel")

   ##console.log recentlyRemovedAssociatedModelId
   ##console.log detailsInfo

    indexOfDeleted = null
    itemTracked = null
    toHighLightDetailView = null

    #process the detail views to be highlighted when deleting a detail view that was last highlighted
    _(detailsInfo).each (el) ->
      if(el.aId == recentlyRemovedAssociatedModelId)

        indexOfDeleted = _.indexOf(detailsInfo, el)
        if(indexOfDeleted == detailsInfo.length - 1)
         ##console.log("get the previous one")
          toHighLightDetailView = detailsInfo[indexOfDeleted - 1]
        else
         ##console.log('one after')
          toHighLightDetailView = detailsInfo[indexOfDeleted + 1]
        itemTracked = detailsInfo[indexOfDeleted]

    #console.log "to highlight is "
    #console.log toHighLightDetailView.id

    #to indicate which detail will need to be highlighted
    @exerciseAndDetails.set("toBeHighlightedDetail", toHighLightDetailView.id)

    #$(@.el).find('#' + toHighLightDetailView.id).trigger("click")

    #update the private model details views for removing a detail
    @privateExerciseModel.set("newlyAddedDetails", _.difference(detailsInfo, itemTracked))

   ##console.log "details views are now"
   ##console.log @privateExerciseModel.get("newlyAddedDetails")
    ###

    #a detail entry will be removed
    @exerciseAssociation.get("entry_detail")
      .remove(@exerciseAndDetails
      .get("recentlyRemovedDetailsAssociatedModel"))

    #signal to parent that a update is needed
    @model.set("signalParentForm", @model.get("signalParentForm") * -1)

  checkForEntries: (event) ->
    #if entries are not present, add entries
    if $(event.target).html() == ""
      $(event.target).html(@model.get "optionListEntries")

    #remove event listeners regardless
    @$el.off("focus", ".add-workout-exercise-drop-downlist")
    @$el.off("click", ".add-workout-exercise-drop-downlist")

  addExercise: (event)->
    #create a new grouping container for the new exercise
    @$el.parent().append("<div class='exercise-grouping row-fluid' id='exercise-grouping'></div>")

   ##console.log "the model before adding new exercise is "
   ##console.log @model

    #generate a new exercise entry
    new Weightyplates.Views.WorkoutExercise(model: @model)

  removeExercise: ()->
    #list of all the views
    exerciseViews = @model.get("exerciseViews")

    #the current view id
    currentCiewId = @cid

    #remove exerciseViews reference when deleting this view
    exerciseViewsFiltered = _(exerciseViews).reject((el) ->
      el.viewId is currentCiewId
    )

    #update the model after removal
    @model.set("exerciseViews", exerciseViewsFiltered)

    thisView = @

    #exercise removal fadeout animation
    @$el.fadeOut(200, ->
      #remove view and event listeners attached to it; event handlers first
      thisView.stopListening()
      thisView.undelegateEvents()
      thisView.remove()
    )

    #remove the exercise remove button, if only one exercise left is left as a result
    if exerciseViewsFiltered.length == 1
      $hiddenExerciseRemove = @model.get("exerciseViews")[0].view.$el
        .find('.add-workout-exercise-remove-button')
        .addClass('hide-add-workout-button')
      @model.set("hiddenExerciseRemoveButton",$hiddenExerciseRemove)

    #send signal to form to remove the exercise entry from json
    signalParentForm = @model.get "signalParentForm"
    @model.set("recentlyRemovedExerciseAssociatedModel", @exerciseAssociation)
    @model.set("signalParentForm", signalParentForm * -1)

  validateListChange: (event)->
    #getting the selected value from the option list
    $parentElement = @$el
    selectedOption = $parentElement.find("select.#{event.target.className} option:selected")
    selectedId = selectedOption.data("id")

    #attempt to set the attribute
    attributeToChange = "exercise_id"
    @exerciseAssociation.set(attributeToChange, selectedId, {validateAll: true, changedAttribute: attributeToChange})

    #get errors if they exist
    @exerciseAssociation.errors["exercise_id"] || ''

    #cache elements
    $controlGroup = $parentElement.find('.dropdown-control')
    $dropDownList = $parentElement.find(".#{event.target.className}")

    #adding and removal of validation error messages
    #first blick if for removing and second block is for adding
    hasErrors = _.has(@exerciseAssociation.errors, "exercise_id")
    if hasErrors == false and @exerciseAndDetails.get("dropDownListError") == true

      #console.log "removing errors exercise"

      $controlGroup.removeClass('error')
      $dropDownList.siblings().remove()
      @exerciseAndDetails.set("dropDownListError", false)
      #@exerciseAssociation.unset("invalidExercise", {silent: true})
    else if hasErrors == true and @exerciseAndDetails.get("dropDownListError") == false

      #console.log "adding exercise errors"

      $controlGroup.addClass('error')

      errors = @exerciseAssociation.errors["exercise_id"]
      alertMsg = "<div class='alert alert-error select-list-error-msg'>#{errors}</div>"
      $dropDownList.after(alertMsg)
      @exerciseAndDetails.set("dropDownListError", true)
      @exerciseAssociation.set("exercise_id", null)




