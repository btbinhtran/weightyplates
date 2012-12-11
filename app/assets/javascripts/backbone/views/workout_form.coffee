class Weightyplates.Views.WorkoutEntryButton extends Backbone.View

  template: JST['dashboard/workout_entry_button']

  events:
    'click #add-workout': 'addWorkoutFormState'

  initialize: ->
    #workoutModel = new class Weightyplates.Models.Workout()

    @model = new Weightyplates.Models.Dashboard()
    @model.fetch()

  render: ->
    $(@el).html(@template())
    this

  addWorkoutFormState: (event) ->
    if @model.defaults.appState[0].addWorkoutForm == true
      $('#add-workout').click (event)->
        event.preventDefault()
    else if @model.defaults.appState[0].addWorkoutForm == false
      @loadWorkoutForm(event)

  loadWorkoutForm: (event) ->
    @model.defaults.appState[0].addWorkoutForm = true
    appStateForm = @model.defaults.appState[0].addWorkoutForm

    class Weightyplates.Views.DashboardIndex extends Backbone.View

      template: JST['dashboard/index']

      initialize: ->
        $('#container').html(@template())

      render: ->
        this

    addWorkoutView = new Weightyplates.Views.DashboardIndex()
    $("#add-workout").click ->
      @blur()
      $(".dashboard-add-workout-modal-row").addClass("dashboard-add-workout-modal-row-show  row-fluid").removeClass "dashboard-add-workout-modal-row"
    hideAddWorkoutDialog = ->
      $('.dashboard-add-workout-modal-row-show').addClass("dashboard-add-workout-modal-row").removeClass("dashboard-add-workout-modal-row-show")

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

    $('#container').find('.add-workout-exercise-drop-downlist').html(optionsList)


    hideAddWorkoutDialog = ->
      $('.dashboard-add-workout-modal-row-show').addClass("dashboard-add-workout-modal-row").removeClass("dashboard-add-workout-modal-row-show")





