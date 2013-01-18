class Weightyplates.Views.WorkoutDetail extends Backbone.View

  template: JST['dashboard/workout_entry_detail']

  el: '#latest-details-container'

  events:
    'click .add-workout-reps-add-button': 'addDetails'
    'click .add-workout-reps-remove-button': 'removeDetails'

  initialize: (options) ->
    #keep track of the view exercises being added and count them
    @privateModel = options.privateModel


    console.log "private model is now"
    console.log @privateModel

    privateModel = @privateModel.get("detailViews")
    privateModelCount = @privateModel.get("detailViewsCount") + 1
    privateModel.push({viewId: @cid, viewSetNumber: privateModelCount})
    @privateModel.set("detailViewsCount", privateModelCount)
    @privateModel.set("detailViews", privateModel)

    #creating detailsAssociation model for this view
    detailsAssociation = new Weightyplates.Models.DetailsAssociations({set_number: privateModelCount, weight: null, reps: null})

    #to signal to parent view, exercise, what child has been added
    @model.set("recentlyAddedDetailsAssociatedModel", detailsAssociation)

    @render(privateModelCount)

  render: (privateModelCount) ->
    #insert template into element
    @$el.append(@template())

    #attach the right set number onto the set label
    @$el.find('.add-workout-set-label').text('S' + privateModelCount)

    #remove the id some subsequent templates can have the same id name
    @$el.removeAttr("id")

    #make all references of 'this' to reference the main object
    _.bindAll(@)

    this

  addDetails: ->
    #prepare a new div to insert another details view
    @$el.parent().append("<div class='row-fluid details-set-weight' id='latest-details-container'></div>")

    #create the new details view
    new Weightyplates.Views.WorkoutDetail(model: @model, privateModel: @privateModel)

  removeDetails: ()->
    console.log "removing"

    #the current view id
    currentCiewId = @cid

    #list of all the views
    detailViews = @privateModel.get("detailViews")



    #only allow removal if there is at least two details row
    if detailViews.length >= 2

      #remove detailViews reference when deleting this view
      detailViewsFiltered = _(detailViews).reject((el) ->
        el.viewId is currentCiewId
      )

      #update the privateModel after removal
      @privateModel.set("detailViews", detailViewsFiltered)

      console.log @privateModel

      #delete all events before removing view
      @stopListening()
      @undelegateEvents()
      @remove()

    else
      alert "Must have at least one set for exercise"




