class Weightyplates.Views.WorkoutEntryButton extends Backbone.View

  template: JST['dashboard/workout_entry_button']

  events:
    'click #add-workout': 'loadWorkoutForm'

  render: ->
    $(@el).html(@template())
    this

  loadWorkoutForm: (event) ->
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

    class Weightyplates.Views.DashboardIndex extends Backbone.View

      template: JST['dashboard/index']

      initialize: ->
        addWorkoutView = $('#container').html(@template())
        addWorkoutView.find('.add-workout-exercise-drop-downlist').html(optionsList)

      render: ->
        this

    addWorkoutView = new Weightyplates.Views.DashboardIndex()

