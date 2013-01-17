class Weightyplates.Views.WorkoutDetail extends Backbone.View

  template: JST['dashboard/workout_entry_detail']

  el: '#latest-details-container'

  events:
    'click .add-workout-reps-add-button': 'addDetails'

  initialize: (options) ->
    #call on render

    #creating detailsAssociation model for this view
    detailsAssociation = new Weightyplates.Models.DetailsAssociations({set_number: null, weight: null, reps: null})

    console.log "details model"
    console.log @model

    #to signal to parent view, exercise, what child has been added
    @model.set("recentlyAddedDetailsAssociatedModel", detailsAssociation)


    ###
    #indicate which view has recently changed
    @model.set("recentlyAddedDetailsAssociatedModel", detailsAssociation)

    #request a change by signalling the parent view
    @model.set("requestParentWorkoutView", (@model.get "requestParentWorkoutView") * -1)
    ###

    @render()

  render: () ->
    #insert template into element
    @$el.append(@template())

    #remove the id some subsequent templates can have the same id name
    @$el.removeAttr("id")

    #make all references of 'this' to reference the main object
    _.bindAll(@)

    this

  addDetails: ->
    #prepare a new div to insert another details view
    @$el.parent().append("<div class='row-fluid details-set-weight' id='latest-details-container'></div>")

    #create the new details view
    new Weightyplates.Views.WorkoutDetail(model: @model)




