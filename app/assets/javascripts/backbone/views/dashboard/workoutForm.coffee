class Weightyplates.Views.WorkoutForm extends Backbone.View

  template: JST['dashboard/workout_form']
  templateNote: JST['dashboard/workout_note']

  el: '#workout-form-container'

  events:
    'focus input.dashboard-workout-name-input': 'focusInWorkoutName'
    'blur input.dashboard-workout-name-input': 'blurInWorkoutName'
    'click #workout-form-main-close-button': 'closeAddWorkoutDialog'
    'click #last-row-note-button': 'addNote'
    'click #last-row-container': 'divider'
    'blur .dashboard-workout-name-input': 'getWorkoutName'
    'mousedown #last-row-save-button': 'clickSaveMouseDown'
    'click #last-row-save-button': 'clickSave'
    'mousedown #last-row-cancel-button': 'clickCancelMouseDown'
    'click #last-row-cancel-button': 'clickCancel'

  initialize: (options)->
    #make all references of 'this' to reference the main object
    _.bindAll(@)

    #model for workout form and exercises
    #manual clearing of arrays properties in models
    formAndExercisesModel = new Weightyplates.Models.FormAndExercises({      exerciseViews: [], exercisesViewIndex: []})

    #prepare the option entries
    formAndExercisesModel.set("optionListEntries", formAndExercisesModel.prepareEntries())

    #create an associated user model for workouts and further nesting of associated models
    associatedUserModel = new Weightyplates.Models.AssociationUserSession()
    associatedWorkoutModel = new Weightyplates.Models.AssociationWorkout()
    associatedUserModel.set({workout: [associatedWorkoutModel]})

    #set the workout name date into form and exercises
    formAndExercisesModel.set("workoutNameDefault", associatedUserModel.get("workout").at(0).get("name"))

    #allows child view to notify this view of a requested change
    formAndExercisesModel.on("change:signalParentForm", @updateAssociatedModel)

    #private form model to listen to events from child views
    privateFormModel = new Weightyplates.Models.PrivateForm()

    #adding models to the form collection
    @collection = new Weightyplates.Collections.FormCollection([
      formAndExercisesModel
      associatedUserModel
      associatedWorkoutModel
      privateFormModel
    ])

    #call render
    @render()

  render: ()->
    #load the view template
    @$el.html(@template())

    #form view gets the FormAndExercises model
    exerciseViewParam =
      formAndExercisesModel: @getModel('FormAndExercises')
    new Weightyplates.Views.WorkoutExercise(exerciseViewParam)




    rearrangeViews = @rearrangeViews

    #sortable on exercises
    $exerciseViewContainer = @$el.find('.workout-entry-exercise-and-sets-row')
    $exerciseDragContainer = @$el.find('.dashboard-add-workout-modal-row-area')

    formAndExercisesModel = @getModel('FormAndExercises')
    associationWorkoutModel = @getModel('AssociationWorkout').get("workout_entries")


    $viewEl = @$el

    $(document).keydown (event) ->
      if event.which == 27
        if (formAndExercisesModel.get("isSorting") == true)
          formAndExercisesModel.set("escPressed", true)

          $exerciseViewContainer.sortable('extra')
          ###
          console.log formAndExercisesModel.get("sortingPrevItem")
          console.log formAndExercisesModel.get("sortingNextItem")
          console.log "----------------------------"

          previd = formAndExercisesModel.get("sortingPrevItem")

          $placeHolder = $viewEl.find('.exercise-place-holder')

          $("##{previd}").after($placeHolder)

          $(this).trigger('mouseup')
          ###

    ###
    $exerciseViewContainer.draggable
      start:
        console.log "dragging"

     ###

    $.ui.sortable.prototype.extra = ()->
      console.log "extra"

    $exerciseViewContainer.sortable
      axis: 'y'
      opacity: 0.9
      containment: $exerciseDragContainer
      placeholder: 'exercise-place-holder'
      forcePlaceHolderSize: false
      delay: 100
      revert: 50
      tolerance: "pointer"

      ###
      #change: ->
      #  console.log "there is a change"

      sort: (event, ui) ->
        #console.log formAndExercisesModel.get("escPressed")
        if(formAndExercisesModel.get("escPressed") == true)
          #console.log "esc pressed"
          $(ui.sender).sortable('cancel');
        #console.log "event"
        #console.log event
        #if event.which == 27
        #  console.log "stop"
      ###

      activate: (event, ui) ->
        formAndExercisesModel.set("isSorting", true)

        #console.log this.constructor
        #console.log formAndExercisesModel.get "isSorting"
        #console.log formAndExercisesModel.get ""
        ###
        $uiItem = $(ui.item)
        exerciseId = $uiItem[0].id
        $prevItem = $uiItem.prev('.exercise-grouping')
        $nextItem = $uiItem.next('.exercise-grouping')

        prevItemId = $prevItem.attr("id")
        nextItemId = $nextItem.attr("id")

        #console.log $uiItem.siblings()
        #console.log $uiItem.closest('.exercise-grouping')
        ###
        #console.log $prevItem
        #console.log $nextItem

        #formAndExercisesModel.set("sortingPrevItem", prevItemId)
        #formAndExercisesModel.set("sortingNextItem", nextItemId)


        #console.log "prev"
        #console.log $prevItem


        #console.log "next"
        #console.log $nextItem

        #$placeHolder = $exerciseDragContainer.find('.exercise-place-holder')
        #$placeHolder.wrap("<div class='row-fluid' />")


      deactivate: (event, ui) ->
        formAndExercisesModel.set("isSorting", false)
        console.log formAndExercisesModel.get "isSorting"
        #dropped item id
        $uiItem = $(ui.item)
        exerciseId = $uiItem[0].id

        exercisesIndex = formAndExercisesModel.get("exercisesViewIndex")

        #for updating the index and the association models
        $prevItem = $uiItem.prev('.exercise-grouping')
        $nextItem = $uiItem.next('.exercise-grouping')

        rearrange = false

        #determine if there is an item before or after the dragged item
        if $prevItem.length == 1
          #there is something before the dragged item
          neighborInfo = "somethingBefore"
          neighborPosition = $prevItem
          rearrange = true
        else if $nextItem.length == 1
          #there is something after the dragged item
          neighborInfo = "somethingAfter"
          neighborPosition = $nextItem
          rearrange = true

        #update index view and the details json
        if rearrange == true
          #console.log 'REARRANge'
          rearrangeViews(exercisesIndex, exerciseId, neighborPosition, neighborInfo, associationWorkoutModel, formAndExercisesModel)


    #add hint in workout name
    @hintInWorkoutName()

    this

  updateAssociatedModel: ->
    #add and removal check for entries
    associationWorkoutModel = @getModel('AssociationWorkout')
    formAndExerciseModel = @getModel('FormAndExercises')

    if associationWorkoutModel.get("workout_entries")
      #remove if there is already an entry
      if associationWorkoutModel.get("workout_entries")
          .get(formAndExerciseModel
          .get("recentlyRemovedExerciseAssociatedModel"))
        associationWorkoutModel.get("workout_entries")
          .remove(formAndExerciseModel
          .get("recentlyRemovedExerciseAssociatedModel"))
       else
        #add instead of overwriting if there already a workout entry
        associationWorkoutModel.get("workout_entries")
          .add(formAndExerciseModel
          .get("recentlyAddedExerciseAssociatedModel"))
    else
      workoutEntryParams =
        workout_entries: [formAndExerciseModel.get "recentlyAddedExerciseAssociatedModel"]
      associationWorkoutModel.set(workoutEntryParams)

    #console.log "association form"
    #console.log associationWorkoutModel.get("workout_entries")

    #console.log formAndExerciseModel.get("exerciseViews")

  focusInWorkoutName: (event) ->
    $this = $(event.target)
    if $this.attr('class') == "dashboard-workout-name-input hint"
      $this.val("").removeClass("hint")

  blurInWorkoutName: (event) ->
    $this = $(event.target)
    if $this.val().length == 0
      $this
        .val(@getModel('FormAndExercises').get("workoutNameHint"))
        .addClass "hint"

  hintInWorkoutName: ->
    $workoutNameInput = @$el.find('input.dashboard-workout-name-input')
    $workoutNameInput
      .val(@getModel('FormAndExercises').get("workoutNameHint"))
      .addClass('hint')

  closeButtonConfirmationHandler: (msg, okRes, notOkRes)->
    if (confirm(msg))
      console.log okRes
    else
      console.log notOkRes

  closeAddWorkoutDialog: (event) ->
    #confirmation messages
    closeButonConfirmationMsg = @getModel('PrivateForm').get("closeButtonConfirmationMsg")
    changesMsg = closeButonConfirmationMsg["changes"]
    changeMsg = closeButonConfirmationMsg["change"]

    #need to assign this because of sharing of function
    theCaller = "closeAddWorkoutDialog"

    #retrieve the fields information
    fieldResults = @validateBeforeSave(theCaller)

    #nicknames for fields
    unfilledFields = fieldResults.totalUnFilledFields
    totalFields = fieldResults.totalFields
    errorFields = fieldResults.totalFieldErrors
    filledFields = totalFields - unfilledFields - errorFields

    #cache the condition of the workout name
    workoutName = @getModel('FormAndExercises').get("workoutName")
    workoutNameCond = !_.isNull(workoutName) and !_.isUndefined(workoutName)
    changesCond = (unfilledFields < totalFields) or errorFields > 0

    #for the workout name
    if workoutNameCond
      if changesCond
        @closeButtonConfirmationHandler(changesMsg, "Yes to delete.", "No to delete.")
      else
        @closeButtonConfirmationHandler(changeMsg, "Yes to delete.", "No to delete.")

    #for when there is no workout name
    else if changesCond
      if(filledFields + errorFields == 1)
        @closeButtonConfirmationHandler(changeMsg, "Yes to delete.", "No to delete.")
      else if(filledFields > 1 or errorFields > 1 or filledFields + errorFields > 1)
        @closeButtonConfirmationHandler(changesMsg, "Yes to delete.", "No to delete.")
    else
      console.log "close out the form"

  addNote: ->
    #console.log JSON.stringify(@getModel('AssociationUserSession'))
    if @$el.find('.text-area-row').length < 1
      templateNote = @templateNote()
      @$el.find('.workout-entry-exercise-and-sets-row').after(templateNote)

  divider: ->
    console.log JSON.stringify(@getModel('AssociationUserSession'))
    console.log @getModel('AssociationUserSession').toJSON()['workout']

  fromSaveButtonTrigger: ->
    #need to specify the caller because of sharing of function with close button
    theCaller = "triggerSaveButton"
    @validateBeforeSave(theCaller)

  getWorkoutName: (event)->
    formAndExerciseModel = @getModel('FormAndExercises')
    if event.target.className.split(' ').length < 2
      formAndExerciseModel.set("workoutName", event.target.value)
    else
      formAndExerciseModel.set("workoutName", null)

  validateBeforeSave: (theCaller)->
    #get data from associated model to evaluate validness
    associatedModels = @getModel('AssociationUserSession').get("workout[0]").get("workout_entries")

    workoutEntryLength = associatedModels.length

    #process the data in the private model
    results = @getModel('PrivateForm').checkErrorsAndUnfilled(associatedModels, workoutEntryLength)

    #if the close button trigger this action
    if theCaller == "closeAddWorkoutDialog"
      #return information of fields to the close dialog action
      results
    else
      @saveWorkoutMsgHandler(results.totalFieldErrors, results.totalUnFilledFields)

  saveWorkoutMsgHandler: (totalFieldErrors, totalUnFilledFields)->
    @saveWorkout()
    ###
    #get alert messages from model
    saveWorkoutMsg = @getModel('PrivateForm').get("saveWorkoutMsg")

    #display appropriate alert message when error or missing fields are encountered or not
    if(totalFieldErrors + totalUnFilledFields) == 0
      @saveWorkout()
    else
      if totalFieldErrors > 0 and totalUnFilledFields > 0
        if totalFieldErrors > 1 and totalUnFilledFields > 1
          alert saveWorkoutMsg["errorsAndUnfills"]
        else if totalFieldErrors == 1 and totalUnFilledFields > 1
          alert saveWorkoutMsg["errorAndUnfills"]
        else if totalFieldErrors > 1 and totalUnFilledFields == 1
          alert saveWorkoutMsg["errorsAndUnfill"]
        else if totalFieldErrors == 1 and totalUnFilledFields == 1
          alert saveWorkoutMsg["errorAndUnfill"]
      else
        if totalFieldErrors > 0
          if totalFieldErrors == 1
            alert saveWorkoutMsg["oneError"]
          else
            alert saveWorkoutMsg["manyErrors"]
        else if totalUnFilledFields > 0
          if totalUnFilledFields == 1
            alert saveWorkoutMsg["missingField"]
          else
            alert saveWorkoutMsg["missingFields"]
    ###

  saveWorkout: ->
    ###
    #prepare the json for sending
    jsonData = JSON.stringify(@getModel('AssociationUserSession'))

    #formatting the jsonData by removing the first '[' and last ']'
    jsonDataLastRightBracketIndex = jsonData.lastIndexOf(']')

    intermediateString = jsonData.substring(jsonDataLastRightBracketIndex + 1)
    rightBracketRemovedJson = jsonData.substring(0, jsonDataLastRightBracketIndex) + intermediateString

    properlyFormattedJson = rightBracketRemovedJson.replace("[", '')

    #properlyFormattedJson = properlyFormattedJson.replace("workout_entry", 'workout_entries_attributes')
    properlyFormattedJson = properlyFormattedJson.replace(/"workout_entry":/g, '"workout_entries":')

    #properlyFormattedJson = properlyFormattedJson.replace("entry_detail", 'entry_details_attributes')
    properlyFormattedJson = properlyFormattedJson.replace(/"entry_details":/g, '"entry_details":')
    ###

    associationUserModel = @getModel('AssociationUserSession')

    $viewElement = @$el

    #console.log properlyFormattedJson
    console.log associationUserModel.toJSON()

    $areaOverLayForAjax = $viewElement.find('.for-ajax-request')

    opts =
      lines: 11 # The number of lines to draw
      length: 30 # The length of each line
      width: 10 # The line thickness
      radius: 40 # The radius of the inner circle
      corners: 1 # Corner roundness (0..1)
      rotate: 0 # The rotation offset
      color: "#000" # #rgb or #rrggbb
      speed: 1 # Rounds per second
      trail: 60 # Afterglow percentage
      shadow: false # Whether to render a shadow
      hwaccel: false # Whether to use hardware acceleration
      className: "spinner" # The CSS class to assign to the spinner
      zIndex: 2e9 # The z-index (defaults to 2000000000)
      top: "auto" # Top position relative to parent in px
      left: "auto" # Left position relative to parent in px

    $.ajax
      type: "POST"
      url: "/api/workouts"
      dataType: "JSON"
      data: associationUserModel.toJSON()
      beforeSend: ->
        console.log 'sending request'
        $spinnerArea = $areaOverLayForAjax
        $spinnerArea.addClass('showSpinner')
        spinner = new Spinner(opts).spin($spinnerArea[0])
      success: () ->
        console.log "successfully save workout."
        #console.log @
        $areaOverLayForAjax
          .removeClass('showSpinner')
      error: (jqXHR, textStatus, errorThrown) ->
        console.log jqXHR.status
        console.log(
          "The following error occurred: " +
          textStatus + errorThrown
        )
        $areaOverLayForAjax
          .removeClass('showSpinner')


  clickSaveMouseDown: (event)->
    event.preventDefault()

  clickSave: (event)->
    event.preventDefault()
    @$el.find(':focus').trigger('blur')
    @validateBeforeSave()

  clickCancelMouseDown: (event)->
    event.preventDefault()

  clickCancel: (event)->
    event.preventDefault()
    @$el.find(':focus').trigger('blur')
    @$el.find('#workout-form-main-close-button').trigger('click')



