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

    #Weightyplates.Views.WorkoutForm::formUtil = setCollection
    addWorkoutView = new Weightyplates.Views.WorkoutForm({model: @collection.models[0], inherit: utilityFunctions})


#viewButton = new Weightyplates.Views.WorkoutEntryButton(collection: @collection)
#$('.add-workout-button-area').html(viewButton.render().el)








