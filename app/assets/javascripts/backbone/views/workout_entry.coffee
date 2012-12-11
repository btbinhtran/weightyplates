class Weightyplates.Views.WorkoutEntryButton extends Backbone.View

  template: JST['dashboard/workout_entry_button']

  events:
    'click #add-workout': 'loadWorkoutForm'

  render: ->
    $(@el).html(@template())
    this

  loadWorkoutForm: (event) ->
    class Weightyplates.Views.DashboardIndex extends Backbone.View

      template: JST['dashboard/index']

      initialize: ->
        $('#container').html(@template())



      render: ->
        this

    addWorkoutView = new Weightyplates.Views.DashboardIndex()


    @collection = new Weightyplates.Collections.DashboardItems()
    @collection.fetch()
    @collection.on('reset', @somethingHappen, this)

  somethingHappen: ->
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
    $(document).on "keypress", (event) ->
      hideAddWorkoutDialog() if event.keyCode == 27

    hideAddWorkoutDialog = ->
      $('.dashboard-add-workout-modal-row-show').addClass("dashboard-add-workout-modal-row").removeClass("dashboard-add-workout-modal-row-show")

    $("#add-workout").click ->
      @blur()
      $(".dashboard-add-workout-modal-row").addClass("dashboard-add-workout-modal-row-show  row-fluid").removeClass "dashboard-add-workout-modal-row"

    $('#collapse-button').click ->
      hideAddWorkoutDialog()



