class Weightyplates.Routers.Dashboard extends Backbone.Router
  routes:
    '': 'index'

  initialize: ->
    @collection = new Weightyplates.Collections.DashboardItems()
    @collection.reset(Weightyplates.PreloadModels)

  index: ->
    #functions for extending the form view and child views
    extendingClass = ->
    extendingClass.prototype = {
      getModel: (modelName) ->
        _.filter(@collection.models, (model) ->
          model.constructor.name == modelName
        )[0]

      getEventTarget: (event)->
        $(event.target)

      toTitleCase: (str) ->
        #utility function for title casing the key
        str.replace /\w\S*/g, (txt) ->
          txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()
    }

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

    augment( Weightyplates.Views.WorkoutForm, extendingClass)
    augment( Weightyplates.Views.WorkoutExercise, extendingClass)
    augment( Weightyplates.Views.WorkoutDetail, extendingClass)

    formViewParams =
      model: @collection.models[0]
    addWorkoutView = new Weightyplates.Views.WorkoutForm(formViewParams)

#viewButton = new Weightyplates.Views.WorkoutEntryButton(collection: @collection)
#$('.add-workout-button-area').html(viewButton.render().el)








