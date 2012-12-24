class Weightyplates.Views.CalculatorResults extends Backbone.View

  template: JST['calculator/calculator_results']

  el: '.calculator-results-area'

  initialize: ->
    $(@el).html(@template())

  render: ->
    this







