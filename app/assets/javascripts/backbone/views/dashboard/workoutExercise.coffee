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

    #render the template
    @render(exercisePhrase, @model.get "optionListEntries")

  render: (exercisePhrase, optionsList)->
    viewElModel = @model

    #the main exercise row
    $workoutExeciseMainRow = @$el

    #append template because there will be further exercise entries
    $workoutExeciseMainRow.append(@template())

    #find the recently added exercise entry from the template append
    $workoutRowFound = $workoutExeciseMainRow.find('#exercise-grouping')

    #details container is for the set and weight rows
    $detailsContainer = $workoutRowFound.find('.an-entry-detail')

    #preparing an additional container for the set and weight rows
    $detailsContainer.append("<div class='row-fluid details-set-weight' id='latest-details-container'></div>")

    #the workout details row
    $detailsRow = new Weightyplates.Views.WorkoutDetail()

    #define the @$el element because it is empty
    @$el = $workoutRowFound.removeAttr("id")

    #add the number label for the exercise; remove id because subsequent entries will have the same id
    $('#an-Exercise-label').text(exercisePhrase).removeAttr("id")

    #keep track of the view exercises being added
    exerciseViews = @model.get("exerciseViews")

    exerciseViews.push(viewExercise: @)
    @model.set("exerciseViews", exerciseViews)

    #make all references of 'this' to reference the main object
    _.bindAll(@)

    #settings for the hoverIntent plugin
    #load the exercises when the mouses hovers
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

  checkForEntries: (event) ->
    #if entries are not there, add entries
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

