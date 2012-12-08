class Weightyplates.Views.DashboardIndex extends Backbone.View

  template:  JST['dashboard/index']

  initialize: ->
    @model.on('reset', @render, this)

  render: ->
    $(@el).html(@template(workouts: @model.toJSON()))
    this

