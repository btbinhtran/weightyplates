class Weightyplates.Views.WorkoutEntryButton extends Backbone.View

  template: JST['dashboard/workout_entry_button']

  events:
    'click #add-workout': 'loadWorkoutForm'

  render: ->
    $(@el).html(@template())
    this

  loadWorkoutForm: (event) ->
    @collection = new Weightyplates.Collections.DashboardItems()
    @collection.fetch()
    @collection.on('reset', @somethingHappen, this)

    #$('.button-area').html("<button id='add-workout'>Add Working outs</button>")




    #view = new Weightyplates.Views.DashboardIndex()
  #$('#container').html(view.render().el)
    #alert('here')
    #@collection.fetch()
    #@collection.on('reset', @render, this)

  somethingHappen: ->
    thisIsMe = @collection
    theModels = thisIsMe.models
    theCollectionLength = thisIsMe.length

    entry = 0
    optionsList = []
    optionsList.push("<option></option>")
    while entry < theCollectionLength
      optionsList.push("<option>#{ theModels[entry].get "name" }</option>")
      entry++
    #console.log(@collection.models)
    #alert('here')
    #alert('here')
    #console.log($('.main-category'))
    #stuff = @.collection.models

    #view = new Weightyplates.Views.DashboardIndex()
    #$('#container').html(@.template2())
    #$('#container').html(view.render().el)
    class Weightyplates.Views.DashboardIndex extends Backbone.View

      template: JST['dashboard/index']

      initialize: ->
        #console.log()
        #console.log('in init')
        #console.log(@template())
        #console.log($('#container'))
        addWorkoutView = $('#container').html(@template())
        console.log(addWorkoutView)


      render: ->
        this

    #console.log(stuff)
    #console.log(optionsList)
    addWorkoutView = new Weightyplates.Views.DashboardIndex()
    #console.log(addWorkoutView.find('add-workout-exercise-drop-downlist'))
    #console.log(something.$el)
