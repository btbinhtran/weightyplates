class Weightyplates.Views.WorkoutDetail extends Backbone.View

  template: JST['dashboard/workout_entry_detail']

  initialize: (options) ->

    $detailsContainer = options.exerciseParentContainer.find('#an-entries-details')

    @render($detailsContainer)

  render: (container) ->
    container.append(@template())

