class Weightyplates.Views.WorkoutExercise extends Backbone.View

  template: JST['dashboard/workout_entry_exercise']

  el: '#exercise-grouping'

  events:
    'click .add-workout-exercise-add-button': 'addExercise'
    'click .add-workout-exercise-remove-button': 'removeExercise'
    'click .add-workout-exercise-drop-downlist': 'checkForEntries'
    'focus .add-workout-exercise-drop-downlist': 'checkForEntries'
    'blur .add-workout-exercise-drop-downlist': 'validateListChange'

  #==============================================Initialize
  initialize: (options)->
    #make all references of 'this' to reference the main object
    _.bindAll(@)

    #for when another exercise view creates this view
    formAndExercisesModel = options.formAndExercisesModel

    #keep track of the exerciseviews and count
    exerciseViews = formAndExercisesModel.get("exerciseViews")
    exerciseViewsCount = formAndExercisesModel.get("exerciseViewsCount") + 1
    exerciseViews.push({view: @, viewId: @cid, viewExerciseNumber: exerciseViewsCount})
    formAndExercisesModel.set("exerciseViewsCount", exerciseViewsCount)
                        .set("exerciseViews", exerciseViews)

    #need to add one for starting at a zero index
    exercisePhrase = "Exercise #{exerciseViewsCount}"

    #creating exerciseAssociation model for this view
    associationExerciseParams = {workout_entry_number: exerciseViewsCount + "", exercise_id: 0}
    exerciseAssociationModel = new Weightyplates.Models.AssociationExercise(associationExerciseParams)

    #model shared between the form and the exercise
    exerciseAssociatedModels = formAndExercisesModel.get("exerciseAssociatedModels")

    #add to the exercise association model array tracker
    exerciseAssociatedModels.push(exerciseAssociationModel)
    formAndExercisesModel.set("exerciseAssociatedModels", exerciseAssociatedModels)

    #indicate which exercise associated model was recently added
    formAndExercisesModel.set("recentlyAddedExerciseAssociatedModel", exerciseAssociationModel)

    #manual reset of details index views for not clearing properly
    #seem to affect arrays types on model even after new instantiation
    #model between exercises and details
    exerciseAndDetailsParams = {detailViews: [], detailViewsCount: null, detailsViewIndex: []}
    exerciseAndDetailsModel = new Weightyplates.Models.ExerciseAndDetails(exerciseAndDetailsParams)

    #allows child view to request a change in associated model for the parent
    exerciseAndDetailsModel.on("change:recentlyAddedDetailsAssociatedModel", @updateAssociatedModelAdd, @)

    #allows parent view to know of this view's requests
    exerciseAndDetailsModel.on("change:signalExerciseForm", @updateDetailsHandler, @)

    #private model for exercise
    privateExerciseModel = new Weightyplates.Models.PrivateExercise()

    #adding models to the exercise collection
    @collection = new Weightyplates.Collections.ExerciseCollection([
      exerciseAssociationModel
      formAndExercisesModel
      exerciseAndDetailsModel
      privateExerciseModel
    ])

    #render the template
    @render(exercisePhrase, formAndExercisesModel, exerciseViewsCount)

  #==============================================Render
  render: (exercisePhrase, formAndExercisesModel, exerciseViewsCount)->
    #console.log @getModel('ExerciseAndDetails')
    $optionList = formAndExercisesModel.get("optionListEntries")

    viewElModel = formAndExercisesModel

    #the main exercise row
    $workoutExeciseRow = @$el

    #----------------------------------------------Generate a Exercise View and Details

    #append template because there will be further exercise entries
    $workoutExeciseRow.append(@template())

    #remove the id of the exercise row because subsequent exercise will have the same id
    @$el.removeAttr("id")

    #remove the remove button in the beginning when there is only one exercise
    if formAndExercisesModel.get("exerciseViews").length == 1
      $hiddenExerciseRemove = @$el.find('.add-workout-exercise-remove-button').addClass('hide-add-workout-button')
      formAndExercisesModel.set("hiddenExerciseRemoveButton", $hiddenExerciseRemove)
    else
      $hiddenExerciseRemove = formAndExercisesModel.get "hiddenExerciseRemoveButton"
      $hiddenExerciseRemove.removeClass('hide-add-workout-button')

    #details container is for the set and weight rows
    $detailsContainer = $workoutExeciseRow.find('.an-entry-detail')

    #preparing an additional container for the set and weight rows
    $detailsContainer.append("<div class='row-fluid details-set-weight' id='latest-details-container'></div>")

    #the workout details row has a model between the exercises and its details
    #have to initialize model to default values because it can take on old values from other exercise sets
    new Weightyplates.Views.WorkoutDetail({exerciseAndDetails: @getModel('ExerciseAndDetails')})

    #add the number label for the exercise; remove id because subsequent entries will have the same id
    @$el.find('#an-Exercise-label').text(exercisePhrase).removeAttr("id")

    #----------------------------------------------Event Listener: Hover Intent

    #settings for the hoverIntent plugin
    #only load the exercises when the mouses hovers over the select list
    settings =
      sensitivity: 10
      interval: 10
      over: ->
        $(@).html($optionList)
        $(@).off()
      out: ->

    #insert entries into option list
    $optionList =  $workoutExeciseRow.find('.add-workout-exercise-drop-downlist')

    #attaching event listener here because it's not a backbone event
    $optionList.hoverIntent settings

    $detailsSet = $(@el).find('.dashboard-exercise-set')

    #exercise and details model
    exerciseAndDetailsModel = @getModel('ExerciseAndDetails')

    #console.log "exercise and details begin exercise is "
    #console.log @getModel('ExerciseAndDetails')

    #exercise association model
    exerciseAssociationModel = @getModel('AssociationExercise')

    exerciseViewEl = @$el

    #----------------------------------------------Sortable Details List with JqueryUi

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
        $detailViewDragged = $(ui.item)
        detailId = $detailViewDragged.attr("id")
        focusInput = $("##{detailId} :focus")
        #there is actually a focused input before initiating the sort
        if focusInput.length > 0
          classNameFocused = focusInput[0].className
          $("##{detailId} :input.#{classNameFocused}").trigger('click')
          #for the dropped event to cause the blur event for validation to trigger
          exerciseAndDetailsModel.set("focusedInputWhenDragged", true)
          exerciseAndDetailsModel.set("classNameOfInputFocus", classNameFocused)
        else
          # no input focus; general click ok
          $detailViewDragged.trigger('click')

      deactivate: (event, ui)->
        #trigger a blur event to make up for the blur validation when sorting
        if exerciseAndDetailsModel.get("focusedInputWhenDragged")
          focusInput = exerciseAndDetailsModel.get("classNameOfInputFocus")
          detailId = $(ui.item)[0].id
          $("##{detailId} :input.#{focusInput}").trigger('blur')

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
    $(@el).find('.details-set-weight').trigger("click")

    #return this
    this

  getModel: (modelName) ->
    _.filter(@collection.models, (model) ->
      model.constructor.name == modelName
    )[0]

  updateAssociatedModelAdd: ->
    #entry details updated the parent exercise
    #subsequent entry details will be added instead
    associationExerciseModel = @getModel('AssociationExercise')
    associationExerciseEntryDetail = associationExerciseModel.get("entry_detail")
    exerciseAndDetailsModel = @getModel('ExerciseAndDetails')
    formAndExerciseModel = @getModel('FormAndExercises')

    if associationExerciseEntryDetail
      associationExerciseEntryDetail
        .add(exerciseAndDetailsModel.get("recentlyAddedDetailsAssociatedModel"))
    else
      entryDetailParam = {entry_detail: [exerciseAndDetailsModel.get("recentlyAddedDetailsAssociatedModel")]}
      associationExerciseModel.set(entryDetailParam)

    #keep track of the added details
    viewId = exerciseAndDetailsModel.get("recentlyAddedDetailsViewId")
    associationId = exerciseAndDetailsModel.get("recentlyAddedDetailsAssociatedModelId")
    detailsViewInfo = {id: viewId, aId: associationId}
    detailsIndex = exerciseAndDetailsModel.get("detailsViewIndex")
    detailsIndex.push(detailsViewInfo)
    exerciseAndDetailsModel.set("detailsViewIndex", detailsIndex)

    #console.log "added to details to index"
    #console.log @getModel('ExerciseAndDetails')
    #console.log '-----------------------------------------__'

    #signal to parent view that a update is needed
    formAndExerciseModel.set("signalParentForm", formAndExerciseModel.get("signalParentForm") * -1)

  updateDetailsHandler: ->
    #responding to a request
    request = @getModel('ExerciseAndDetails').get("recentDetailsViewAction")
    if request == "removing"
      @updateAssociatedModelRemove()
    else if request == "highlighting"
      @highLightDetails()

  highLightDetails: ->
    #perform a click to hightlight when the last focused highlighted detail was deleted
    detailForHighlighting = @getModel('ExerciseAndDetails').get("toBeHighlightedDetail")
    @$el.find('#' + detailForHighlighting).trigger('click')

  updateAssociatedModelRemove: ()->
    #update associated model remove
    exerciseAndDetailsModel = @getModel('ExerciseAndDetails')
    recentlyRemovedAssociatedModelId = exerciseAndDetailsModel.get("recentlyRemovedDetailsAssociatedModel").cid
    detailsInfo = exerciseAndDetailsModel.get("detailsViewIndex")
    formAndExercisesModel = @getModel('FormAndExercises')

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

    #console.log "start id tracking"

    exerciseAndDetailsModel.set("toBeHighlightedDetail", toHighLightDetailView.id)

    #update the private model details views for removing a detail
    exerciseAndDetailsModel.set("detailsViewIndex", _.difference(detailsInfo, itemTracked))

    #a detail entry will be removed
    @getModel('AssociationExercise')
      .get("entry_detail")
      .remove(exerciseAndDetailsModel.get("recentlyRemovedDetailsAssociatedModel"))

    #signal to parent that a update is needed
    formAndExercisesModel.set("signalParentForm", formAndExercisesModel.get("signalParentForm") * -1)

  checkForEntries: (event) ->
    #if entries are not present, add entries
    if $(event.target).html() == ""
      $(event.target).html(@getModel('FormAndExercises').get "optionListEntries")

    #remove event listeners regardless
    @$el.off("focus", ".add-workout-exercise-drop-downlist")
    @$el.off("click", ".add-workout-exercise-drop-downlist")

  addExercise: (event)->
    #create a new grouping container for the new exercise
    @$el.parent().append("<div class='exercise-grouping row-fluid' id='exercise-grouping'></div>")

    #generate a new exercise entry
    new Weightyplates.Views.WorkoutExercise(formAndExercisesModel: @getModel('FormAndExercises'))

  removeExercise: ()->
    #list of all the views
    formAndExercisesModel = @getModel('FormAndExercises')
    exerciseViews = formAndExercisesModel.get("exerciseViews")

    #the current view id
    currentCiewId = @cid

    #remove exerciseViews reference when deleting this view
    exerciseViewsFiltered = _(exerciseViews).reject((el) ->
      el.viewId is currentCiewId
    )

    #update the model after removal
    formAndExercisesModel.set("exerciseViews", exerciseViewsFiltered)

    #remove the exercise remove button, if only one exercise left is left as a result
    if exerciseViewsFiltered.length == 1
      $hiddenExerciseRemove = formAndExercisesModel.get("exerciseViews")[0].view.$el
        .find('.add-workout-exercise-remove-button')
        .addClass('hide-add-workout-button')
      formAndExercisesModel.set("hiddenExerciseRemoveButton", $hiddenExerciseRemove)

    #send signal to form to remove the exercise entry from json
    signalParentForm = formAndExercisesModel.get "signalParentForm"
    formAndExercisesModel.set("recentlyRemovedExerciseAssociatedModel", @getModel('AssociationExercise'))
    formAndExercisesModel.set("signalParentForm", signalParentForm * -1)

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

    thisView.remove()

  validateListChange: (event)->
    #getting the selected value from the option list
    $parentElement = @$el
    selectedOption = $parentElement.find("select.#{event.target.className} option:selected")
    selectedId = selectedOption.data("id")

    #attempt to set the attribute
    attributeToChange = "exercise_id"
    validateAllParams = {validateAll: true, changedAttribute: attributeToChange}
    associationExerciseModel = @getModel('AssociationExercise')
    associationExerciseModel.set(attributeToChange, selectedId, validateAllParams)

    #get errors if they exist
    associationExerciseModel.errors["exercise_id"] || ''

    #cache elements
    $controlGroup = $parentElement.find('.dropdown-control')
    $dropDownList = $parentElement.find(".#{event.target.className}")

    #adding and removal of validation error messages
    #first block if for removing and second block is for adding
    hasErrors = _.has(associationExerciseModel.errors, "exercise_id")
    if hasErrors == false and @getModel('ExerciseAndDetails').get("dropDownListError") == true
      $controlGroup.removeClass('error')
      $dropDownList.siblings().remove()
      @getModel('ExerciseAndDetails').set("dropDownListError", false)
      #associationExerciseModel.unset("invalidExercise", {silent: true})
    else if hasErrors == true and @getModel('ExerciseAndDetails').get("dropDownListError") == false
      $controlGroup.addClass('error')
      errors = associationExerciseModel.errors["exercise_id"]
      alertMsg = "<div class='alert alert-error select-list-error-msg'>#{errors}</div>"
      $dropDownList.after(alertMsg)
      @getModel('ExerciseAndDetails').set("dropDownListError", true)
      associationExerciseModel.set("exercise_id", null)
