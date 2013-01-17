class Weightyplates.Views.WorkoutExercise extends Backbone.View

  template: JST['dashboard/workout_entry_exercise']

  events:
    'click .add-workout-exercise-add-button': 'addExercise'
    'click .add-workout-exercise-remove-button': 'removeExercise'
    'click .add-workout-exercise-drop-downlist': 'checkForEntries'
    'focus .add-workout-exercise-drop-downlist': 'checkForEntries'

  el: '.workout-entry-exercise-and-sets-row'

  initialize: ()->
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
    $workoutExeciseMainRow = @$el

    #----------------------------------------------Generate a Exercise View and Details

    #append template because there will be further exercise entries
    $workoutExeciseMainRow.append(@template())

    #find the recently added exercise entry from the template append
    $workoutRowFound = $workoutExeciseMainRow.find('#exercise-grouping')

    #details container is for the set and weight rows
    $detailsContainer = $workoutRowFound.find('.an-entry-detail')

    #preparing an additional container for the set and weight rows
    $detailsContainer.append("<div class='row-fluid details-set-weight' id='latest-details-container'></div>")

    #the workout details row
    new Weightyplates.Views.WorkoutDetail(model: @exerciseAndDetailsModel)

    #define the @$el element because it is empty
    @$el = $workoutRowFound.removeAttr("id")

    #add the number label for the exercise; remove id because subsequent entries will have the same id
    $('#an-Exercise-label').text(exercisePhrase).removeAttr("id")


    ###example usage with backbone association
    detailAssociation = new Weightyplates.Models.DetailsAssociations({reps: 1, weight: 5, set_number: 2})

    detailAssociation2 = new Weightyplates.Models.DetailsAssociations({reps: 8, weight: 4, set_number: 9})

    exerciseAssociation = new Weightyplates.Models.ExercisesAssociations({exercise_id: 2})

    exerciseAssociation2 = new Weightyplates.Models.ExercisesAssociations({exercise_id: 3})

    workoutAssociation = new Weightyplates.Models.WorkoutsAssociations()

    userAssociation = new Weightyplates.Models.UserSessionAssociations()




    exerciseAssociation.set({entry_detail: [detailAssociation, detailAssociation2]})
    exerciseAssociation2.set({entry_detail: [detailAssociation2, detailAssociation2]})

    workoutAssociation.set({workout_entry: [exerciseAssociation, exerciseAssociation2]})

    userAssociation.set({workout:workoutAssociation })

    #console.log workoutAssociation
    #console.log exerciseAssociation.get("details").models
    #console.log exerciseAssociation.get("details").models[0]
    #console.log exerciseAssociation.get("details").models[0].get "reps"

    console.log JSON.stringify(userAssociation)
    ###


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
    $optionLists =  $workoutRowFound.find('.add-workout-exercise-drop-downlist')

    #attaching event listener here because it's not a backbone event
    $optionLists.hoverIntent settings

    #return this
    this

  updateAssociatedModel: ->
    console.log "exercise needs updating"

    #entry details updated the parent exercise
    #subsequent entry details will be added
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
    #generate a new exercise entry
    new Weightyplates.Views.WorkoutExercise(model: @model)

  removeExercise: (event)->
    if @model.get("exerciseCount") > 1

      #more care is needed if the exercise is not the last
      notTheLast = (@model.get("lastExercise").cid != @cid)

      #if not last entry, then the first and middle entries will need to save ref
      if notTheLast
        #the first or middle entry
        $siblings = @$el.nextAll()

      #remove view and event listeners attached to it; event handlers first
      @stopListening()
      @undelegateEvents()
      @remove()

      #decrementing the exercise labels when deleting exercise entries
      if notTheLast
        $siblingExerciseLabels = $siblings.find('.add-workout-exercise-label')
        $siblingExerciseLabels.each ->
          oldNumber = parseInt($(this).text().replace(/Exercise /g, ''))
          $(this).text("Exercise #{oldNumber - 1}")

      #decrement the exercise count
      @model.set("exerciseCount", @model.get("exerciseCount") - 1)

    else
      alert "A workout must have at least one exercise."

