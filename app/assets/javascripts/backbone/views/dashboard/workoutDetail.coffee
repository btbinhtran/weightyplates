class Weightyplates.Views.WorkoutDetail extends Backbone.View

  template: JST['dashboard/workout_entry_detail']

  el: '#latest-details-container'

  events:
    'click .add-workout-reps-add-button': 'addDetails'

  initialize: (options) ->

    ###
    class privateModel extends Backbone.Model

      defaults:
        privateCall: -1
        recentDetailsContainer: null

    @model = new privateModel()

    #console.log @model



    $detailsContainer = options.detailContainer

    @render($detailsContainer)

    ###

    @render()


  render: () ->
    #console.log @

    @$el.append(@template())

    @$el.removeAttr("id")



    #@el = @template()

    #console.log @
    ###
    containerContents = container.html()

    newContents = containerContents + @template()
    #insert the template

    container.html(newContents)

    #.append(@template())

    #define the @$el element because it is empty
    @$el = container


    #define the el element because it is empty
    @el = @$el[0]

    ###

    @

  addDetails: ->
    console.log "outer add"

    @$el.parent().append("<div class='row-fluid' id='latest-details-container'></div>")

    new Weightyplates.Views.WorkoutDetail()
    #@model.set("recentDetailsContainer", @$el)

    #@model.set("privateCall", @model.get("privateCall") * -1)




