class Weightyplates.Views.WorkoutDetail extends Backbone.View

  template: JST['dashboard/workout_entry_detail']

  events:
    'click .add-workout-reps-add-button': 'addDetails'

  initialize: () ->

    #$detailsContainer = options.exerciseParentContainer
    #console.log "first"
    #console.log $detailsContainer
    $container = $('.workout-entry-exercise-and-sets-row').find('#an-entries-details')
    console.log "container now is "
    console.log $container
    @render($container)

  render: (container) ->

    #insert the template
    container.append(@template())

    #define the @$el element because it is empty
    @$el = container




    #remove the id from entry details; subsequent entries will have the same id
    #container.removeAttr("id")

    console.log container

    #define the el element because it is empty
    @el = @$el[0]

    this

  addDetails: ->
    console.log "adding"
    #console.log @$el
    new Weightyplates.Views.WorkoutDetail()

