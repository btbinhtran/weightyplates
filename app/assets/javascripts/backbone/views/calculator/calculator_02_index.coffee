

class Weightyplates.Views.CalculatorIndex extends Backbone.View

  template: JST['calculator/calculator_index']

  initialize: ->


  render: ->
    $(@el).html(@template())
    this

