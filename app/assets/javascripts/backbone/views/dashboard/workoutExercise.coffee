class Weightyplates.Views.WorkoutExercise extends Backbone.View

  template: JST['dashboard/workout_entry_exercise']

  events:
    'click .add-workout-exercise-add-button': 'addExercise'
    'click .add-workout-exercise-remove-button': 'removeExercise'
    'click .add-workout-exercise-drop-downlist': 'checkForEntries'
    'focus .add-workout-exercise-drop-downlist': 'checkForEntries'

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

    #console.log "first exer view count"
    #console.log  @model.get("exerciseViews").length

    #need to add one for starting at a zero index
    exercisePhrase = "Exercise #{exerciseViewsCount}"

    #creating exerciseAssociation model for this view
    @exerciseAssociation = new Weightyplates.Models.ExercisesAssociations({exercise_id: null})

    #if @model.get("exerciseAssociatedModels").length == 1
    #  console.log "something is already there"

    #model shared between the form and the exercise
    exerciseAssociatedModels = @model.get("exerciseAssociatedModels")

    #add to the exercise association model array tracker
    exerciseAssociatedModels.push(@exerciseAssociation)
    @model.set("exerciseAssociatedModels", exerciseAssociatedModels)

    #indicate which exercise associated model was recently added
    @model.set("recentlyAddedExerciseAssociatedModel", @exerciseAssociation)

    #model between exercises and details
    @amongExercises = new Weightyplates.Models.AmongExercises()

    #allows child view to request a change in associated model for the parent
    @amongExercises.on("change:recentlyAddedDetailsAssociatedModel", @updateAssociatedModelAdd, @)

    #console.log "among exercises"
    #console.log @amongExercises

    @amongExercises.on("change:signalExerciseForm", @updateAssociatedModelRemove, @)


    #render the template
    @render(exercisePhrase, @model.get("optionListEntries"), exerciseViewsCount)

  #==============================================Render
  render: (exercisePhrase, optionsList, exerciseViewsCount)->
    viewElModel = @model

    #the main exercise row
    $workoutExeciseRow = @$el

    #console.log "new container is "
    #console.log @

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

    #the workout details row has a private model between the exercises and its details
    #have to initialize private model to default values because it can take on old values from other exercise sets
    new Weightyplates.Views.WorkoutDetail(model: @amongExercises, privateModel: new Weightyplates.Models.ExerciseDetails(detailViews: [], detailViewsCount: null))

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
       #console.log @exerciseAssociation.get("entry_detail").length
      @exerciseAssociation.get("entry_detail").add(@amongExercises.get("recentlyAddedDetailsAssociatedModel"))
    else
      @exerciseAssociation.set({entry_detail: [@amongExercises.get("recentlyAddedDetailsAssociatedModel")]})

    #signal to parent that a update is needed
    @model.set("signalParentForm", @model.get("signalParentForm") * -1)

  updateAssociatedModelRemove: ->
    console.log "request removal"

    #a detail entry will be removed
    @exerciseAssociation.get("entry_detail").remove(@amongExercises.get("recentlyRemovedDetailsAssociatedModel"))

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
    #console.log "adding another exercise ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    #console.log @$el

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

    #update the privateModel after removal
    @model.set("exerciseViews", exerciseViewsFiltered)

    #remove the exercise remove button, if only one exercise left is left as a result
    if exerciseViewsFiltered.length == 1
      $hiddenExerciseRemove = @model.get("exerciseViews")[0].view.$el
        .find('.add-workout-exercise-remove-button')
        .addClass('hide-add-workout-button')
      @model.set("hiddenExerciseRemoveButton",$hiddenExerciseRemove)

    #remove view and event listeners attached to it; event handlers first
    @stopListening()
    @undelegateEvents()
    @remove()


