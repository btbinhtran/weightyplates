class Weightyplates.Routers.Dashboard extends Backbone.Router
  routes:
    '': 'index'
    'pastworkouts': 'pastworkouts'

  initialize: ->
    @collection = new Weightyplates.Collections.DashboardItems()
    @collection.reset(Weightyplates.PreloadModels)

  index: ->
    #the Mixin object used for extending
    genMixIn = ->
    genMixIn.prototype = {
      getModel: (modelName) ->
        _.filter(@collection.models, (model) ->
          model.constructor.name == modelName
        )[0]

      toTitleCase: (str) ->
        #utility function for title casing the key
        str.replace /\w\S*/g, (txt) ->
          txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()
    }

    viewRearrangeMixin = ->
    viewRearrangeMixin.prototype = {
      #sharing this view with
      rearrangeViews: (detailsViewIndex, draggedDetailId, neighboringItem, areaInfo, associationExerciseEntryDetail, exerciseAndDetailsModel) ->
        #entry details association models
        entryDetailsModel =  associationExerciseEntryDetail.models

        #get ids of all the views in the index
        allDetailsId = _.pluck(detailsViewIndex, 'id')

        #association ids for details
        detailsAssociationIds = _.pluck(entryDetailsModel, 'cid')

        #the index of dragged item before it was dragged
        draggedOldIndex =  _.indexOf(allDetailsId, draggedDetailId)

        #the item's original index which is now the item next to the dragged item
        nextToItemIndexOfDragged = _.indexOf(allDetailsId,  neighboringItem.attr("id"))

        #the index info of the dragged item
        indexOfDragged = detailsViewIndex[draggedOldIndex]

        #the index info of the item next to the dragged item
        indexItemNextToTheDragged = detailsViewIndex[nextToItemIndexOfDragged]

        nextToItemAssociation = entryDetailsModel[nextToItemIndexOfDragged]
        toMoveDetails = entryDetailsModel[draggedOldIndex]

        #create a temp array for storing into the previous
        tempArray = []
        tempArray2 = []

        if areaInfo == "somethingBefore"
          tempArray.push(indexItemNextToTheDragged, indexOfDragged)
          tempArray2.push(nextToItemAssociation, toMoveDetails)
        else
          tempArray.push(indexOfDragged, indexItemNextToTheDragged)
          tempArray2.push(toMoveDetails, nextToItemAssociation)

        #overwrite the item next to the dragged item in the index view
        #do it for association details model too
        detailsViewIndex[nextToItemIndexOfDragged] = tempArray
        entryDetailsModel[nextToItemIndexOfDragged] = tempArray2

        #flatten the index view array and store to model
        detailsViewIndexString = detailsViewIndex + ""
        exerciseAndDetailsModel.set(detailsViewIndexString, _.flatten(_.without(detailsViewIndex, detailsViewIndex[draggedOldIndex])))

        #shift dragged details around for association details
        #delete the old model belonging to dragged details
        #update the association details when done
        delete entryDetailsModel[draggedOldIndex]

        entryDetailsModel = _.flatten(_.without(entryDetailsModel, nextToItemAssociation))
        entryDetailsModel = _.compact(entryDetailsModel)
        associationExerciseEntryDetail.models = entryDetailsModel
    }

    #functions for extending the form view and child views
    augment = (receivingClass, givingClass)->
      if arguments[2]
        i = 2
        len = arguments.length
        while i < len
          receivingClass.prototype[arguments[i]] = givingClass.prototype[arguments[i]]
          i++
      else
        keysGiving = _.keys(givingClass.prototype)
        keyCountGiving = _.keys(givingClass.prototype).length
        i = 0
        while i < keyCountGiving
          keyGiving = keysGiving[i]
          if !receivingClass.prototype[keyGiving]
            receivingClass.prototype[keyGiving] = givingClass.prototype[keyGiving]
          i++

    #provide the methods to the backbone objects (views, models, etc.)
    toAugment = [
      {class: Weightyplates.Views.WorkoutForm
      augmentingObj: viewRearrangeMixin
      items: "ALL"}

      {class: Weightyplates.Views.WorkoutForm
      augmentingObj: genMixIn
      items: "getModel"}

      {class: Weightyplates.Views.WorkoutExercise
      augmentingObj: genMixIn
      items: "getModel"}

      {class: Weightyplates.Views.WorkoutExercise
      augmentingObj: viewRearrangeMixin
      items: "ALL"}

      {class: Weightyplates.Models.AssociationDetail
      augmentingObj: genMixIn
      items: "toTitleCase"}

      {class: Weightyplates.Views.WorkoutDetail
      augmentingObj: genMixIn
      items: "ALL"}
    ]

    #perform the augmenting
    (groupAugment = (toAugment, augment) ->
      l = toAugment.length
      i = 0
      while i < l
        entry = toAugment[i]
        if entry.items == "ALL"
          augment(entry.class, entry.augmentingObj)
        else
          augment(entry.class, entry.augmentingObj, entry.items)
        i++
    )(toAugment, augment)

    formViewParams =
      model: @collection.models[0]
    addWorkoutView = new Weightyplates.Views.WorkoutForm(formViewParams)

    #highlighting the sub-category type
    $('#workout-main')
      .addClass('dashboard-active-subcategory')
      .removeClass(' dashboard-inactive-subcategory')
    $('#past-workouts')
      .removeClass('dashboard-active-subcategory')
      .addClass(' dashboard-inactive-subcategory')

  pastworkouts: ->
    #console.log 'past workouts'
    #highlighting the sub-category type
    $('#workout-form-container').empty();
    $('#workout-form-container').html("<p>Pastworkouts</p>")
    $('#past-workouts')
      .addClass('dashboard-active-subcategory')
      .removeClass(' dashboard-inactive-subcategory')
    $('#workout-main')
      .removeClass('dashboard-active-subcategory')
      .addClass(' dashboard-inactive-subcategory')


#viewButton = new Weightyplates.Views.WorkoutEntryButton(collection: @collection)
#$('.add-workout-button-area').html(viewButton.render().el)








