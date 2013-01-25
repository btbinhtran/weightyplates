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

    #console.log "exercises"

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
    @exerciseAssociation = new Weightyplates.Models.AssociationExercise({workout_entry_number: exerciseViewsCount + "", exercise_id: null})

    #console.log "exercise set id to null"

    #model shared between the form and the exercise
    exerciseAssociatedModels = @model.get("exerciseAssociatedModels")

    #add to the exercise association model array tracker
    exerciseAssociatedModels.push(@exerciseAssociation)
    @model.set("exerciseAssociatedModels", exerciseAssociatedModels)

    #indicate which exercise associated model was recently added
    @model.set("recentlyAddedExerciseAssociatedModel", @exerciseAssociation)

    #model between exercises and details
    @exerciseAndDetails = new Weightyplates.Models.ExerciseAndDetails()

    #console.log "before exer on change"

    #allows child view to request a change in associated model for the parent
    @exerciseAndDetails.on("change:recentlyAddedDetailsAssociatedModel", @updateAssociatedModelAdd, @)

    #console.log "After exercise on change"

    @exerciseAndDetails.on("change:signalExerciseForm", @updateAssociatedModelRemove, @)

    #console.log "another after exerc"

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
      #console.log "only one exercise present"
      $hiddenExerciseRemove = @$el.find('.add-workout-exercise-remove-button').addClass('hide-add-workout-button')
      @model.set("hiddenExerciseRemoveButton",$hiddenExerciseRemove)
      #console.log @model.get "hiddenExerciseRemoveButton"
    else
      $hiddenExerciseRemove = @model.get "hiddenExerciseRemoveButton"
      $hiddenExerciseRemove.removeClass('hide-add-workout-button')

    #details container is for the set and weight rows
    $detailsContainer = $workoutExeciseRow.find('.an-entry-detail')

    #preparing an additional container for the set and weight rows
    $detailsContainer.append("<div class='row-fluid details-set-weight' id='latest-details-container'></div>")

    #console.log "exer private model"

    #the workout details row has a private model between the exercises and its details
    #have to initialize private model to default values because it can take on old values from other exercise sets
    new Weightyplates.Views.WorkoutDetail(model: @exerciseAndDetails, exerciseAndDetails: new Weightyplates.Models.ExerciseAndDetails(detailViews: [], detailViewsCount: null))

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

    #return this
    this

  updateAssociatedModelAdd: ->
    #console.log "exercise needs updating"

    #entry details updated the parent exercise
    #subsequent entry details will be added instead
    if @exerciseAssociation.get("entry_detail")
      #console.log "in the get and update exer"
      #console.log @exerciseAssociation.get("entry_detail").length
      @exerciseAssociation.get("entry_detail").add(@exerciseAndDetails.get("recentlyAddedDetailsAssociatedModel"))
    else
      #console.log "in the set exer"
      @exerciseAssociation.set({entry_detail: [@exerciseAndDetails.get("recentlyAddedDetailsAssociatedModel")]})

    #console.log "after the setting and getting"

    #signal to parent that a update is needed
    @model.set("signalParentForm", @model.get("signalParentForm") * -1)

    #console.log "yet another after set and get"

  updateAssociatedModelRemove: ->
    #a detail entry will be removed
    @exerciseAssociation.get("entry_detail").remove(@exerciseAndDetails.get("recentlyRemovedDetailsAssociatedModel"))

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

    #remove view and event listeners attached to it; event handlers first
    @stopListening()
    @undelegateEvents()
    @remove()

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
    if _.has(@exerciseAssociation.errors, "exercise_id") == false and @exerciseAndDetails.get("dropDownListError") == true
      $controlGroup.removeClass('error')
      $dropDownList.siblings().remove()
      @exerciseAndDetails.set("dropDownListError", false)
    else if _.has(@exerciseAssociation.errors, "exercise_id") == true and @exerciseAndDetails.get("dropDownListError") == false
      $controlGroup.addClass('error')
      $dropDownList.after("<div class='alert alert-error select-list-error-msg'>#{@exerciseAssociation.errors["exercise_id"]}</div>")
      @exerciseAndDetails.set("dropDownListError", true)
      @exerciseAssociation.set("exercise_id", null)



