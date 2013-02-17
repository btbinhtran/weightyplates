class Weightyplates.Routers.Dashboard extends Backbone.Router
  routes:
    '': 'index'
    'pastworkouts': 'pastworkouts'

  initialize: ->
    @collection = new Weightyplates.Collections.DashboardItems()
    @collection.reset(Weightyplates.PreloadModels)

  index: ->
    console.log "index router"
    console.log addWorkoutView
    #the Mixin object used for extending
    MixIn = ->
    MixIn.prototype = {
      getModel: (modelName) ->
        _.filter(@collection.models, (model) ->
          model.constructor.name == modelName
        )[0]

      toTitleCase: (str) ->
        #utility function for title casing the key
        str.replace /\w\S*/g, (txt) ->
          txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()
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
    augment(
      Weightyplates.Views.WorkoutForm,
      MixIn,
      'getModel'
    )

    augment(
      Weightyplates.Views.WorkoutExercise,
      MixIn,
      'getModel'
    )

    augment(Weightyplates.Views.WorkoutDetail, MixIn)

    augment(
      Weightyplates.Models.AssociationDetail,
      MixIn,
      'toTitleCase'
    )

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
    console.log 'past workouts'
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








