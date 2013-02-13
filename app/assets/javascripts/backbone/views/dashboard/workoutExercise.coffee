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
    exerciseViews.push({view: @, viewId: @cid, viewExerciseNumber: exerciseViewsCount})
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

    #model between exercises and details
    @exerciseAndDetails = new Weightyplates.Models.ExerciseAndDetails()

    #manual reset of details index views for not clearing properly
    #seem to affect arrays types on model even after new instantiation
    @exerciseAndDetails.set("detailsViewIndex", [])

    #allows child view to request a change in associated model for the parent
    @exerciseAndDetails.on("change:recentlyAddedDetailsAssociatedModel", @updateAssociatedModelAdd, @)

    #allows parent view to know of this view's requests
    @exerciseAndDetails.on("change:signalExerciseForm", @updateDetailsHandler, @)

    #private model for exercise
    @privateExerciseModel = new Weightyplates.Models.PrivateExercise()

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
      @model.set("hiddenExerciseRemoveButton", $hiddenExerciseRemove)
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

    exerciseViewEl = @$el

    #make the details sortable
    $detailsSet.sortable
      axis: 'y'
      opacity: 0.9
      containment: 'parent'
      placeholder: 'place-holder'
      forcePlaceHolderSize: true
      delay: 100
      revert: 50

      activate: (event, ui) ->
        #notify the dragged detail view for changes if necessary
        detailId = $(ui.item).attr("id")
        focusInput = exerciseViewEl.find("##{detailId} :focus")
        #there is actually a focused input before initiating the sort
        if focusInput.length > 0
          classNameFocused = focusInput[0].className
          exerciseViewEl.find('#' + detailId + ' :input.' + classNameFocused).trigger('click')
          #for the dropped event to cause the blur event for validation to trigger
          exerciseAndDetailsModel.set("focusedInputWhenDragged", true)
          exerciseAndDetailsModel.set("classNameOfInputFocus", classNameFocused)
        else
          # no input focus; general click ok
          exerciseViewEl.find('#' + detailId).trigger('click')

      deactivate: (event, ui)->
        #trigger a blur event to make up for the blur validation when sorting
        if exerciseAndDetailsModel.get("focusedInputWhenDragged")
          focusInput = exerciseAndDetailsModel.get("classNameOfInputFocus")
          detailId = $(ui.item).attr("id")
          exerciseViewEl.find("##{detailId} :input.#{focusInput}").trigger('blur')

          #reset the model info
          exerciseAndDetailsModel.set("focusedInputWhenDragged", false)
          exerciseAndDetailsModel.set("classNameOfInputFocus", null)

        #for updating the json
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
    @exerciseAndDetails.set("detailsViewIndex", detailsIndex)

    #signal to parent view that a update is needed
    @model.set("signalParentForm", @model.get("signalParentForm") * -1)

  updateDetailsHandler: ->
    #responding to a request
    request = @exerciseAndDetails.get("recentDetailsViewAction")
    if request == "removing"
      @updateAssociatedModelRemove()
    else if request == "highlighting"
      @highLightDetails()

  highLightDetails: ->
    #perform a click to hightlight when the last focused highlighted detail was deleted
    detailForHighlighting = @exerciseAndDetails.get("toBeHighlightedDetail")
    @$el.find('#' + detailForHighlighting).trigger('click')

  updateAssociatedModelRemove: ()->
    #update associated model remove
    recentlyRemovedAssociatedModelId = @exerciseAndDetails.get("recentlyRemovedDetailsAssociatedModel").cid
    detailsInfo = @exerciseAndDetails.get("detailsViewIndex")

    indexOfDeleted = null
    itemTracked = null
    toHighLightDetailView = null

    #determine if the next detail or previous detail should be highlighted
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

    console.log "start id tracking"

    @exerciseAndDetails.set("toBeHighlightedDetail", toHighLightDetailView.id)

    #update the private model details views for removing a detail
    @exerciseAndDetails.set("detailsViewIndex", _.difference(detailsInfo, itemTracked))

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

    #remove the exercise remove button, if only one exercise left is left as a result
    if exerciseViewsFiltered.length == 1
      $hiddenExerciseRemove = @model.get("exerciseViews")[0].view.$el
        .find('.add-workout-exercise-remove-button')
        .addClass('hide-add-workout-button')
      @model.set("hiddenExerciseRemoveButton", $hiddenExerciseRemove)

    #send signal to form to remove the exercise entry from json
    signalParentForm = @model.get "signalParentForm"
    @model.set("recentlyRemovedExerciseAssociatedModel", @exerciseAssociation)
    @model.set("signalParentForm", signalParentForm * -1)

    thisView = @

    ###
    #exercise removal fadeout animation
    @$el.fadeOut(200, ->
      #remove view and event listeners attached to it; event handlers first
      thisView.stopListening()
      thisView.undelegateEvents()
      thisView.remove()
    )
    ###

    thisView.stopListening()
    thisView.undelegateEvents()
    thisView.remove()

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
      $controlGroup.removeClass('error')
      $dropDownList.siblings().remove()
      @exerciseAndDetails.set("dropDownListError", false)
      #@exerciseAssociation.unset("invalidExercise", {silent: true})
    else if hasErrors == true and @exerciseAndDetails.get("dropDownListError") == false

      $controlGroup.addClass('error')

      errors = @exerciseAssociation.errors["exercise_id"]
      alertMsg = "<div class='alert alert-error select-list-error-msg'>#{errors}</div>"
      $dropDownList.after(alertMsg)
      @exerciseAndDetails.set("dropDownListError", true)
      @exerciseAssociation.set("exercise_id", null)
