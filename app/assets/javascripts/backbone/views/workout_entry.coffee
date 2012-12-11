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
    @collection.on('reset', @somethingHappen)

    #$('.button-area').html("<button id='add-workout'>Add Working outs</button>")




    #view = new Weightyplates.Views.DashboardIndex()
  #$('#container').html(view.render().el)
    #alert('here')
    #@collection.fetch()
    #@collection.on('reset', @render, this)

  somethingHappen: ->
    #alert('here')
    #alert('here')
    #console.log($('.main-category'))

    #view = new Weightyplates.Views.DashboardIndex()
    #$('#container').html(@.template2())
    #$('#container').html(view.render().el)
    class Weightyplates.Views.DashboardIndex extends Backbone.View

      template: JST['dashboard/index']

      initialize: ->
        #console.log('in init')
        #console.log(@template())
        #console.log($('#container'))
        addWorkoutView = $('#container').html(@template())


      render: ->
        #console.log($(@.el))
        #console.log($(@.el))

        #console.log('in render')

      this

    something = new Weightyplates.Views.DashboardIndex()
    #console.log(something.$el)
