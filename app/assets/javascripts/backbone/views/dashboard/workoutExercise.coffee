class Weightyplates.Views.WorkoutExercise extends Backbone.View

  template: JST['dashboard/workout_entry_exercise']

  events:
    'click .add-workout-exercise-add-button': 'addExercise'
    'click .add-workout-exercise-remove-button': 'removeExercise'
    'click .add-workout-exercise-drop-downlist': 'checkForEntries'
    'focus .add-workout-exercise-drop-downlist': 'checkForEntries'

  el: '#exercise-grouping'

  initialize: ()->
    console.log "new exercise is _______________"


    exerciseCount = @model.get "exerciseCount"

    #need to add one for starting at a zero index
    exercisePhrase = "Exercise #{exerciseCount + 1}"

    #marking the first exercise row and later rows
    if @model.get("isFirstExerciseRow") == false
      @model.set("isFirstExerciseRow", true)
      @model.set("firstExercise", @)
    else
      #reference the data from the model that was stored the first time
      optionsList = @model.get("optionListEntries")
      @model.set("lastExercise", @)

    #increment the exercise count for the exercise label
    @model.set("exerciseCount", exerciseCount + 1)

    #creating exerciseAssociation model for this view
    @exerciseAssociation = new Weightyplates.Models.ExercisesAssociations({exercise_id: null})

    if @model.get("exerciseAssociatedModels").length == 1
      console.log "something is already there"

    #model shared between the form and the exercise
    exerciseAssociatedModels = @model.get("exerciseAssociatedModels")

    #add to the exercise association model array tracker
    exerciseAssociatedModels.push(@exerciseAssociation)
    @model.set("exerciseAssociatedModels", exerciseAssociatedModels)

    #indicate which exercise associated model was recently added
    @model.set("recentlyAddedExerciseAssociatedModel", @exerciseAssociation)

    #model between exercises and details
    @exerciseAndDetailsModel = new Weightyplates.Models.ExerciseAndDetails()

    #allows child view to request a change in associated model for the parent
    @exerciseAndDetailsModel.on("change:recentlyAddedDetailsAssociatedModel", @updateAssociatedModel, @)



    #render the template
    @render(exercisePhrase, @model.get "optionListEntries")

  render: (exercisePhrase, optionsList)->
    viewElModel = @model

    #the main exercise row
    $workoutExeciseRow = @$el

    console.log "new container is "
    console.log @




    #----------------------------------------------Generate a Exercise View and Details

    #append template because there will be further exercise entries
    $workoutExeciseRow.append(@template())

    #remove the id of the exercise row because subsequent exercise will have the same id
    @$el.removeAttr("id")

    #details container is for the set and weight rows
    $detailsContainer = $workoutExeciseRow.find('.an-entry-detail')
    #$detailsContainer = $workoutRowFound.find('.an-entry-detail')

    #preparing an additional container for the set and weight rows
    $detailsContainer.append("<div class='row-fluid details-set-weight' id='latest-details-container'></div>")

    #the workout details row
    new Weightyplates.Views.WorkoutDetail(model: @exerciseAndDetailsModel)

    #add the number label for the exercise; remove id because subsequent entries will have the same id
    $('#an-Exercise-label').text(exercisePhrase).removeAttr("id")


    #----------------------------------------------Track Exercise Views

    #keep track of the view exercises being added
    exerciseViews = @model.get("exerciseViews")
    exerciseViews.push(viewExercise: @)
    @model.set("exerciseViews", exerciseViews)

    #make all references of 'this' to reference the main object
    _.bindAll(@)

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

  updateAssociatedModel: ->
    console.log "exercise needs updating"

    #entry details updated the parent exercise
    #subsequent entry details will be added instead
    if @exerciseAssociation.get("entry_detail")
       #console.log @exerciseAssociation.get("entry_detail").length
      @exerciseAssociation.get("entry_detail").add(@exerciseAndDetailsModel.get("recentlyAddedDetailsAssociatedModel"))
    else
      @exerciseAssociation.set({entry_detail: [@exerciseAndDetailsModel.get("recentlyAddedDetailsAssociatedModel")]})

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
    console.log "adding another exercise ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    console.log @$el

    #create a new grouping container for the new exercise
    @$el.parent().append("<div class='exercise-grouping row-fluid' id='exercise-grouping'></div>")

    #generate a new exercise entry
    new Weightyplates.Views.WorkoutExercise(model: @model)

  removeExercise: (event)->
    if @model.get("exerciseCount") > 1

      ###FOR REORDERING

      #more care is needed if the exercise is not the last
      notTheLast = (@model.get("lastExercise").cid != @cid)

      #if not last entry, then the first and middle entries will need to save ref
      if notTheLast
        #the first or middle entry
        $siblings = @$el.nextAll()

      ###

      #remove view and event listeners attached to it; event handlers first
      @stopListening()
      @undelegateEvents()
      @remove()

      ###FOR REORDERING

      #decrementing the exercise labels when deleting exercise entries
      if notTheLast
        $siblingExerciseLabels = $siblings.find('.add-workout-exercise-label')
        $siblingExerciseLabels.each ->
          oldNumber = parseInt($(this).text().replace(/Exercise /g, ''))
          $(this).text("Exercise #{oldNumber - 1}")



      #decrement the exercise count
      @model.set("exerciseCount", @model.get("exerciseCount") - 1)

      ###

    else
      alert "A workout must have at least one exercise."

