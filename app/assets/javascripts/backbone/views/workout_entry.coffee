class Weightyplates.Views.WorkoutEntryButton extends Backbone.View

  template: JST['dashboard/workout_entry_button']

  events:
    'click #add-workout': 'loadWorkoutForm'

  render: ->
    $(@el).html(@template())
    this

  loadWorkoutForm: (event) ->
    #alert('here')
    #@collection.fetch()
    #@collection.on('reset', @render, this)

