class Weightyplates.Views.WorkoutDetail extends Backbone.View

  template: JST['dashboard/workout_entry_detail']

  el: '#latest-details-container'

  events:
    'click .add-workout-reps-add-button': 'addDetails'

  initialize: (options) ->
    #call on render
    @render()

  render: () ->
    #insert template into element
    @$el.append(@template())

    #remove the id some subsequent templates can have the same id name
    @$el.removeAttr("id")

    this

  addDetails: ->
    #prepare a new div to insert another details view
    @$el.parent().append("<div class='row-fluid details-set-weight' id='latest-details-container'></div>")

    #create the new details view
    new Weightyplates.Views.WorkoutDetail()




