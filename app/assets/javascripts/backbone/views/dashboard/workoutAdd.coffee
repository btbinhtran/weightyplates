class Weightyplates.Views.WorkoutEntryButton extends Backbone.View

  template: JST['dashboard/workout_entry_button']

  events:
    'click #add-workout': 'addWorkoutFormState'

  initialize: ->

  render: ->

    $(@el).html(@template())

    this

  addWorkoutFormState: (event) ->
    #console.log $(@el)

    if @model.defaults.appState[0].addWorkoutForm == true
      $('#add-workout').click (event)->
        event.preventDefault()
    else if @model.defaults.appState[0].addWorkoutForm == false
      @loadWorkoutForm(event)

  loadWorkoutForm: (event) ->
    @model.defaults.appState[0].addWorkoutForm = true
    appStateForm = @model.defaults.appState[0].addWorkoutForm

    addWorkoutView = new Weightyplates.Views.workoutForm()

    $("#add-workout").click ->
      @blur()
      $(".dashboard-add-workout-modal-row")
        .addClass("dashboard-add-workout-modal-row-show row-fluid")
        .removeClass "dashboard-add-workout-modal-row"

    hideAddWorkoutDialog = ->
      $('.dashboard-add-workout-modal-row-show')
        .addClass("dashboard-add-workout-modal-row")
        .removeClass("dashboard-add-workout-modal-row-show")

    $('#collapse-button').click ->
      hideAddWorkoutDialog()
      appStateForm = false

    $(document).on "keypress", (event) ->
        if event.keyCode == 27
          hideAddWorkoutDialog()
          appStateForm = false

    @collection = new Weightyplates.Collections.DashboardItems()
    @collection.fetch()
    @collection.on('reset', @theCollectionLoaded, this)

  theCollectionLoaded: ->
    thisIsMe = @collection
    theModels = thisIsMe.models
    theCollectionLength = thisIsMe.length

    entry = 0
    optionsList = []
    optionsList.push("<option></option>")
    while entry < theCollectionLength

      dataIdAttribute = "data-id='" + (theModels[entry].get "id") + "' "
      dataEquipmentAttribute = "data-equipment='" + (theModels[entry].get "equipment") + "' "
      dataForceAttribute = "data-force='" + (theModels[entry].get "force") + "' "
      dataIsSportAttribute = "data-isSport='" + (theModels[entry].get "is_sport") + "' "
      dataLevelAttribute = "data-level='" + (theModels[entry].get "level") + "' "
      dataMechanicsAttribute = "data-mechanics='" + (theModels[entry].get "mechanics") + "' "
      dataMuscleAttribute = "data-muscle='" + (theModels[entry].get "muscle") + "' "
      dataTypeAttribute = "data-type='" + (theModels[entry].get "type") + "' "

      exerciseName = theModels[entry].get "name"
      exerciseName = exerciseName.replace(/'/g, '&#039;')

      valueAttribute = "value='" + exerciseName + "'"

      optionEntry = "<option " + dataIdAttribute + dataEquipmentAttribute + dataForceAttribute + dataIsSportAttribute + dataLevelAttribute + dataMechanicsAttribute + dataMuscleAttribute + dataTypeAttribute  + valueAttribute + ">" + exerciseName + "</option>"

      optionsList.push(optionEntry)
      entry++

    $('#workout-form-container').find('.add-workout-exercise-drop-downlist').html(optionsList)

    hideAddWorkoutDialog = ->
      $('.dashboard-add-workout-modal-row-show')
        .addClass("dashboard-add-workout-modal-row")
        .removeClass("dashboard-add-workout-modal-row-show")





