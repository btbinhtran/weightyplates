class Weightyplates.Views.WorkoutEntryButton extends Backbone.View

  template: JST['dashboard/workout_entry_button']

  events:
    'click #add-workout': 'addWorkoutFormState'

  initialize: ->
    #make all references of 'this' to reference the main object
    _.bindAll(@)

  render: ->
    $(@el).html(@template())
    this

  addWorkoutFormState: (event) ->
    event.target.blur()
    if @collection.models[0].get("showingWorkoutForm") == true
      event.preventDefault()
    else if @collection.models[0].get("showingWorkoutForm") == false && @collection.models[0].get("hidingWorkoutForm") == false
      @loadWorkoutForm()
      @collection.models[0].set("showingWorkoutForm", true)
    else if @collection.models[0].get("hidingWorkoutForm") == true
      $('.dashboard-add-workout-modal-row')
        .addClass("dashboard-add-workout-modal-row-show")
        .removeClass("dashboard-add-workout-modal-row")
      @collection.models[0].set("showingWorkoutForm", true)
      @collection.models[0].set("hidingWorkoutForm", false)

  loadWorkoutForm: () ->
    addWorkoutView = new Weightyplates.Views.WorkoutForm(model: @collection.models[0])
    @collection.models[0].set("showingWorkoutForm", true)







