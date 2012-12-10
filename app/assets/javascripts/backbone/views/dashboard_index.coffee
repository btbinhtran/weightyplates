class Weightyplates.Views.DashboardIndex extends Backbone.View

  template: JST['dashboard/index']

  initialize: ->
    @collection.on('reset', @render, this)
    #console.log(@workouts)

  render: ->
    if @collection.length > 0
      $(@el).html(@template(workouts: @collection.toJSON()))

      $(document).on "keypress", (event) ->
        hideAddWorkoutDialog() if event.keyCode == 27

      hideAddWorkoutDialog = ->
        $('.dashboard-add-workout-modal-row-show').addClass("dashboard-add-workout-modal-row").removeClass("dashboard-add-workout-modal-row-show")

      $("#add-workout").click ->
        @blur()
        $(".dashboard-add-workout-modal-row").addClass("dashboard-add-workout-modal-row-show  row-fluid").removeClass "dashboard-add-workout-modal-row"
        $('#collapse-button').click ->
          hideAddWorkoutDialog()
      console.log(@collection)
    this