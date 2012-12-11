class Weightyplates.Views.DashboardIndex extends Backbone.View

  template: JST['dashboard/index']

  initialize: ->
    @collection.on('reset', @render, this)

  render: ->
    this



