class Weightyplates.Views.DashboardIndex extends Backbone.View

  template:  JST['dashboard/index']

  initialize: ->
    @model.on('reset', @render, this)



  render: ->
    $(@el).html(@template(items: @model.toJSON()))
    console.log(@model.toJSON())
    console.log((@model.toJSON()).dancers[0].gender)
    this

