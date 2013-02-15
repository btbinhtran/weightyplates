class Weightyplates.Routers.Dashboard extends Backbone.Router
  routes:
    '': 'index'

  initialize: ->
    @collection = new Weightyplates.Collections.DashboardItems()

    @collection.reset(Weightyplates.PreloadModels)

  index: ->
    #functions for extending the form view and child views
    utilityFunctions =
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

    #Weightyplates.Views.WorkoutForm::formUtil = setCollection
    formViewParams =
      model: @collection.models[0]
      inherit: utilityFunctions
    addWorkoutView = new Weightyplates.Views.WorkoutForm(formViewParams)

#viewButton = new Weightyplates.Views.WorkoutEntryButton(collection: @collection)
#$('.add-workout-button-area').html(viewButton.render().el)








