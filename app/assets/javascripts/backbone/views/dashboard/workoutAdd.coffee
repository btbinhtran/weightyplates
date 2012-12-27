class Weightyplates.Views.WorkoutEntryButton extends Backbone.View

  template: JST['dashboard/workout_entry_button']

  events:
    'click #add-workout': 'addWorkoutFormState'

  initialize: ->
    @model = new Weightyplates.Models.DashboardState()
    @model.fetch()

  render: ->
    $(@el).html(@template())
    this

  saveWorkout: ->
    alert "attempt save"

  addWorkoutFormState: (event) ->
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
      optionsList.push("<option>#{ theModels[entry].get "name" }</option>")
      entry++

    $('#workout-form-container').find('.add-workout-exercise-drop-downlist').html(optionsList)

    hideAddWorkoutDialog = ->
      $('.dashboard-add-workout-modal-row-show')
        .addClass("dashboard-add-workout-modal-row")
        .removeClass("dashboard-add-workout-modal-row-show")





