class Weightyplates.Views.WorkoutDetail extends Backbone.View

  template: JST['dashboard/workout_entry_detail']

  events:
    'click .add-workout-reps-add-button': 'addDetails'

  initialize: (options) ->

    $detailsContainer = options.detailContainer
    #console.log options
    #console.log $detailsContainer
    #$container = $('.workout-entry-exercise-and-sets-row').find('#an-entries-details')
    #console.log "container now is "
    #console.log $container

    #console.log options

    #if options.fromAdd != undefined
    #  console.log options.fromAdd
    @render($detailsContainer)

  render: (container) ->

    containerContents = container.html()

    newContents = containerContents + @template()
    #insert the template

    container.html(newContents)

    #.append(@template())

    #define the @$el element because it is empty
    @$el = container




    #remove the id from entry details; subsequent entries will have the same id
    #container.removeAttr("id")

    #console.log container

    #define the el element because it is empty
    @el = @$el[0]

    this

  addDetails: ->

    #check on model to prevent double rendering
    if @model
      @model.set("recentDetailsContainer", @$el)
      @model.set("addDetails", @model.get("addDetails")* -1)


