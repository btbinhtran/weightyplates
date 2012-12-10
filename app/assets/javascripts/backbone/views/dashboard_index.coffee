class Weightyplates.Views.DashboardIndex extends Backbone.View

  template: JST['dashboard/index']

  initialize: ->
    @collection.on('reset', @render, this)

  render: ->
    if @collection.length > 0
      $(@el).html(@template(workouts: @collection.toJSON()))

      #$('.button-area').html("<button id='add-workout'>Add Working outs</button>")

      lengthCollection = @collection.length
      entry = 0
      optionsList = []
      optionsList.push("<option></option>")
      while entry < lengthCollection
        optionsList.push("<option>#{ @collection.models[entry].get "name" }</option>")
        entry++

      $('.add-workout-exercise-drop-downlist').html(optionsList)

      $(document).on "keypress", (event) ->
        hideAddWorkoutDialog() if event.keyCode == 27

      hideAddWorkoutDialog = ->
        $('.dashboard-add-workout-modal-row-show').addClass("dashboard-add-workout-modal-row").removeClass("dashboard-add-workout-modal-row-show")

      $("#add-workout").click ->
        @blur()
        $(".dashboard-add-workout-modal-row").addClass("dashboard-add-workout-modal-row-show  row-fluid").removeClass "dashboard-add-workout-modal-row"

      $('#collapse-button').click ->
        hideAddWorkoutDialog()


    this


